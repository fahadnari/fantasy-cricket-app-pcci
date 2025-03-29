/*
  # Update Points Calculation System

  1. Changes
    - Update point values in calculate_match_points() function:
      - Sixes: 3.5 points (was 2)
      - Fours: 2.5 points (was 1)
      - Wickets: 3.5 points (was 10)
      - Catches: 2.5 points (was 5)
      - Stumpings: 2.5 points (was 6)
      - Run outs: 2.5 points (was 4)
      - Added: Dot balls - 1 point each
    - Recalculate points for all existing match performances
    - Update fantasy team total points
*/

-- Add dot_balls column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'match_performances' 
    AND column_name = 'dot_balls'
  ) THEN
    ALTER TABLE match_performances ADD COLUMN dot_balls integer DEFAULT 0;
  END IF;
END $$;

-- Create or replace the points calculation function with new point values
CREATE OR REPLACE FUNCTION calculate_match_points()
RETURNS TRIGGER AS $$
BEGIN
  NEW.points = (
    COALESCE(NEW.sixes, 0) * 3.5 +       -- 3.5 points per six
    COALESCE(NEW.fours, 0) * 2.5 +       -- 2.5 points per four
    COALESCE(NEW.wickets, 0) * 3.5 +     -- 3.5 points per wicket
    COALESCE(NEW.catches, 0) * 2.5 +     -- 2.5 points per catch
    COALESCE(NEW.stumpings, 0) * 2.5 +   -- 2.5 points per stumping
    COALESCE(NEW.run_outs, 0) * 2.5 +    -- 2.5 points per run out
    COALESCE(NEW.dot_balls, 0) * 1.0     -- 1.0 point per dot ball
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Update existing match performances with new point calculations
UPDATE match_performances
SET points = (
  COALESCE(sixes, 0) * 3.5 +       -- 3.5 points per six
  COALESCE(fours, 0) * 2.5 +       -- 2.5 points per four
  COALESCE(wickets, 0) * 3.5 +     -- 3.5 points per wicket
  COALESCE(catches, 0) * 2.5 +     -- 2.5 points per catch
  COALESCE(stumpings, 0) * 2.5 +   -- 2.5 points per stumping
  COALESCE(run_outs, 0) * 2.5 +    -- 2.5 points per run out
  COALESCE(dot_balls, 0) * 1.0     -- 1.0 point per dot ball
);

-- Update fantasy team total points based on their players' performances
WITH player_total_points AS (
  SELECT 
    p.id as player_id,
    COALESCE(SUM(mp.points), 0) as total_points
  FROM players p
  LEFT JOIN match_performances mp ON p.id = mp.player_id
  GROUP BY p.id
)
UPDATE fantasy_teams ft
SET total_points = (
  SELECT COALESCE(SUM(ptp.total_points), 0)
  FROM fantasy_team_selections fts
  JOIN player_total_points ptp ON fts.player_id = ptp.player_id
  WHERE fts.fantasy_team_id = ft.id
);