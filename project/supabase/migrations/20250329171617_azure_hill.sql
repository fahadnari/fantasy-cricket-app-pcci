/*
  # Update Match Performances and Team Points

  1. Changes
    - Add match performances for players
    - Update fantasy team points based on player performances
    - Add more fantasy teams and their selections

  2. Notes
    - Points calculation:
      - Runs: 1 point per run
      - Wickets: 25 points each
      - Catches: 10 points each
      - Sixes: 2 points each
      - Fours: 1 point each
*/

-- Insert match performances using a more reliable approach with CTEs
WITH player_ids AS (
  SELECT id, name FROM players
)
INSERT INTO match_performances (player_id, match_date, sixes, fours, wickets, catches, points)
SELECT 
  p.id,
  date_value,
  sixes_value,
  fours_value,
  wickets_value,
  catches_value,
  NULL as points
FROM (
  VALUES
    ('MS Dhoni', '2025-03-22', 3, 4, 0, 2),
    ('Ravindra Jadeja', '2025-03-22', 1, 6, 2, 1),
    ('Virat Kohli', '2025-03-22', 2, 8, 0, 1),
    ('Glenn Maxwell', '2025-03-22', 4, 5, 1, 0),
    ('Rohit Sharma', '2025-03-23', 3, 7, 0, 1),
    ('Hardik Pandya', '2025-03-23', 2, 4, 2, 1),
    ('Shubman Gill', '2025-03-23', 5, 8, 0, 0),
    ('Rashid Khan', '2025-03-23', 1, 2, 3, 0),
    ('Rishabh Pant', '2025-03-24', 4, 6, 0, 2),
    ('David Warner', '2025-03-24', 3, 8, 0, 1),
    ('Andre Russell', '2025-03-24', 6, 4, 2, 0),
    ('Sunil Narine', '2025-03-24', 1, 2, 4, 1),
    ('Shikhar Dhawan', '2025-03-25', 2, 7, 0, 1),
    ('Sam Curran', '2025-03-25', 3, 5, 3, 0),
    ('Jos Buttler', '2025-03-25', 5, 9, 0, 1),
    ('Trent Boult', '2025-03-25', 0, 0, 4, 1),
    ('KL Rahul', '2025-03-26', 4, 8, 0, 1),
    ('Marcus Stoinis', '2025-03-26', 3, 6, 2, 1),
    ('Pat Cummins', '2025-03-26', 2, 3, 3, 0),
    ('Bhuvneshwar Kumar', '2025-03-26', 0, 1, 3, 1)
  ) AS v(player_name, date_value, sixes_value, fours_value, wickets_value, catches_value)
  JOIN player_ids p ON p.name = v.player_name;

-- Update fantasy team points based on player performances
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

-- Add more fantasy teams
INSERT INTO fantasy_teams (name, owner, total_points) VALUES
  ('Super Strikers', 'Rahul', 0),
  ('Royal Warriors', 'Priya', 0),
  ('Thunder Kings', 'Amit', 0),
  ('Elite Eagles', 'Sneha', 0);

-- Add player selections for new teams using a more reliable approach
DO $$ 
DECLARE
  team_id uuid;
  virat_id uuid;
  buttler_id uuid;
  hardik_id uuid;
  rashid_id uuid;
  rohit_id uuid;
  dhoni_id uuid;
  jadeja_id uuid;
  bumrah_id uuid;
  rahul_id uuid;
  russell_id uuid;
  narine_id uuid;
  boult_id uuid;
  warner_id uuid;
  curran_id uuid;
  cummins_id uuid;
  bhuvi_id uuid;
BEGIN
  -- Get player IDs first
  SELECT id INTO virat_id FROM players WHERE name = 'Virat Kohli' LIMIT 1;
  SELECT id INTO buttler_id FROM players WHERE name = 'Jos Buttler' LIMIT 1;
  SELECT id INTO hardik_id FROM players WHERE name = 'Hardik Pandya' LIMIT 1;
  SELECT id INTO rashid_id FROM players WHERE name = 'Rashid Khan' LIMIT 1;
  SELECT id INTO rohit_id FROM players WHERE name = 'Rohit Sharma' LIMIT 1;
  SELECT id INTO dhoni_id FROM players WHERE name = 'MS Dhoni' LIMIT 1;
  SELECT id INTO jadeja_id FROM players WHERE name = 'Ravindra Jadeja' LIMIT 1;
  SELECT id INTO bumrah_id FROM players WHERE name = 'Jasprit Bumrah' LIMIT 1;
  SELECT id INTO rahul_id FROM players WHERE name = 'KL Rahul' LIMIT 1;
  SELECT id INTO russell_id FROM players WHERE name = 'Andre Russell' LIMIT 1;
  SELECT id INTO narine_id FROM players WHERE name = 'Sunil Narine' LIMIT 1;
  SELECT id INTO boult_id FROM players WHERE name = 'Trent Boult' LIMIT 1;
  SELECT id INTO warner_id FROM players WHERE name = 'David Warner' LIMIT 1;
  SELECT id INTO curran_id FROM players WHERE name = 'Sam Curran' LIMIT 1;
  SELECT id INTO cummins_id FROM players WHERE name = 'Pat Cummins' LIMIT 1;
  SELECT id INTO bhuvi_id FROM players WHERE name = 'Bhuvneshwar Kumar' LIMIT 1;

  -- Super Strikers
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Super Strikers' LIMIT 1;
  IF team_id IS NOT NULL AND virat_id IS NOT NULL AND buttler_id IS NOT NULL AND hardik_id IS NOT NULL AND rashid_id IS NOT NULL THEN
    INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
      (team_id, virat_id, 1),
      (team_id, buttler_id, 2),
      (team_id, hardik_id, 3),
      (team_id, rashid_id, 4);
  END IF;

  -- Royal Warriors
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Royal Warriors' LIMIT 1;
  IF team_id IS NOT NULL AND rohit_id IS NOT NULL AND dhoni_id IS NOT NULL AND jadeja_id IS NOT NULL AND bumrah_id IS NOT NULL THEN
    INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
      (team_id, rohit_id, 1),
      (team_id, dhoni_id, 2),
      (team_id, jadeja_id, 3),
      (team_id, bumrah_id, 4);
  END IF;

  -- Thunder Kings
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Thunder Kings' LIMIT 1;
  IF team_id IS NOT NULL AND rahul_id IS NOT NULL AND russell_id IS NOT NULL AND narine_id IS NOT NULL AND boult_id IS NOT NULL THEN
    INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
      (team_id, rahul_id, 1),
      (team_id, russell_id, 2),
      (team_id, narine_id, 3),
      (team_id, boult_id, 4);
  END IF;

  -- Elite Eagles
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Elite Eagles' LIMIT 1;
  IF team_id IS NOT NULL AND warner_id IS NOT NULL AND curran_id IS NOT NULL AND cummins_id IS NOT NULL AND bhuvi_id IS NOT NULL THEN
    INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
      (team_id, warner_id, 1),
      (team_id, curran_id, 2),
      (team_id, cummins_id, 3),
      (team_id, bhuvi_id, 4);
  END IF;
END $$;