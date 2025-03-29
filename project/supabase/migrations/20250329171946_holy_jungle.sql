/*
  # Update Points Calculation System

  1. Changes
    - Create a function to calculate match points based on player performance
    - Update existing match performances with new point calculations
    - Points system:
      * Sixes: 2 points each
      * Fours: 1 point each
      * Wickets: 10 points each
      * Catches: 5 points each
      * Stumpings: 6 points each
      * Run outs: 4 points each

  2. Notes
    - Points are calculated automatically for new entries via trigger
    - Existing match performances will be updated with new point values
*/

-- Create or replace the points calculation function
CREATE OR REPLACE FUNCTION calculate_match_points()
RETURNS TRIGGER AS $$
BEGIN
  NEW.points = (
    COALESCE(NEW.sixes, 0) * 2 +      -- 2 points per six
    COALESCE(NEW.fours, 0) * 1 +      -- 1 point per four
    COALESCE(NEW.wickets, 0) * 10 +   -- 10 points per wicket
    COALESCE(NEW.catches, 0) * 5 +    -- 5 points per catch
    COALESCE(NEW.stumpings, 0) * 6 +  -- 6 points per stumping
    COALESCE(NEW.run_outs, 0) * 4     -- 4 points per run out
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Update existing match performances with new point calculations
UPDATE match_performances
SET points = (
  COALESCE(sixes, 0) * 2 +      -- 2 points per six
  COALESCE(fours, 0) * 1 +      -- 1 point per four
  COALESCE(wickets, 0) * 10 +   -- 10 points per wicket
  COALESCE(catches, 0) * 5 +    -- 5 points per catch
  COALESCE(stumpings, 0) * 6 +  -- 6 points per stumping
  COALESCE(run_outs, 0) * 4     -- 4 points per run out
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