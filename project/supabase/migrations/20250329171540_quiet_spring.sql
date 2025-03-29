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

-- Insert match performances
INSERT INTO match_performances (player_id, match_date, sixes, fours, wickets, catches, points) VALUES
  -- Match 1: CSK vs RCB
  ((SELECT id FROM players WHERE name = 'MS Dhoni'), '2025-03-22', 3, 4, 0, 2, NULL),
  ((SELECT id FROM players WHERE name = 'Ravindra Jadeja'), '2025-03-22', 1, 6, 2, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Virat Kohli'), '2025-03-22', 2, 8, 0, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Glenn Maxwell'), '2025-03-22', 4, 5, 1, 0, NULL),

  -- Match 2: MI vs GT
  ((SELECT id FROM players WHERE name = 'Rohit Sharma'), '2025-03-23', 3, 7, 0, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Hardik Pandya'), '2025-03-23', 2, 4, 2, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Shubman Gill'), '2025-03-23', 5, 8, 0, 0, NULL),
  ((SELECT id FROM players WHERE name = 'Rashid Khan'), '2025-03-23', 1, 2, 3, 0, NULL),

  -- Match 3: DC vs KKR
  ((SELECT id FROM players WHERE name = 'Rishabh Pant'), '2025-03-24', 4, 6, 0, 2, NULL),
  ((SELECT id FROM players WHERE name = 'David Warner'), '2025-03-24', 3, 8, 0, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Andre Russell'), '2025-03-24', 6, 4, 2, 0, NULL),
  ((SELECT id FROM players WHERE name = 'Sunil Narine'), '2025-03-24', 1, 2, 4, 1, NULL),

  -- Match 4: PBKS vs RR
  ((SELECT id FROM players WHERE name = 'Shikhar Dhawan'), '2025-03-25', 2, 7, 0, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Sam Curran'), '2025-03-25', 3, 5, 3, 0, NULL),
  ((SELECT id FROM players WHERE name = 'Jos Buttler'), '2025-03-25', 5, 9, 0, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Trent Boult'), '2025-03-25', 0, 0, 4, 1, NULL),

  -- Match 5: LSG vs SRH
  ((SELECT id FROM players WHERE name = 'KL Rahul'), '2025-03-26', 4, 8, 0, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Marcus Stoinis'), '2025-03-26', 3, 6, 2, 1, NULL),
  ((SELECT id FROM players WHERE name = 'Pat Cummins'), '2025-03-26', 2, 3, 3, 0, NULL),
  ((SELECT id FROM players WHERE name = 'Bhuvneshwar Kumar'), '2025-03-26', 0, 1, 3, 1, NULL);

-- Update fantasy team points based on player performances
WITH player_total_points AS (
  SELECT 
    p.id as player_id,
    SUM(mp.points) as total_points
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

-- Add player selections for new teams
DO $$ 
DECLARE
  team_id uuid;
BEGIN
  -- Super Strikers
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Super Strikers';
  INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
    (team_id, (SELECT id FROM players WHERE name = 'Virat Kohli'), 1),
    (team_id, (SELECT id FROM players WHERE name = 'Jos Buttler'), 2),
    (team_id, (SELECT id FROM players WHERE name = 'Hardik Pandya'), 3),
    (team_id, (SELECT id FROM players WHERE name = 'Rashid Khan'), 4);

  -- Royal Warriors
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Royal Warriors';
  INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
    (team_id, (SELECT id FROM players WHERE name = 'Rohit Sharma'), 1),
    (team_id, (SELECT id FROM players WHERE name = 'MS Dhoni'), 2),
    (team_id, (SELECT id FROM players WHERE name = 'Ravindra Jadeja'), 3),
    (team_id, (SELECT id FROM players WHERE name = 'Jasprit Bumrah'), 4);

  -- Thunder Kings
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Thunder Kings';
  INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
    (team_id, (SELECT id FROM players WHERE name = 'KL Rahul'), 1),
    (team_id, (SELECT id FROM players WHERE name = 'Andre Russell'), 2),
    (team_id, (SELECT id FROM players WHERE name = 'Sunil Narine'), 3),
    (team_id, (SELECT id FROM players WHERE name = 'Trent Boult'), 4);

  -- Elite Eagles
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Elite Eagles';
  INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
    (team_id, (SELECT id FROM players WHERE name = 'David Warner'), 1),
    (team_id, (SELECT id FROM players WHERE name = 'Sam Curran'), 2),
    (team_id, (SELECT id FROM players WHERE name = 'Pat Cummins'), 3),
    (team_id, (SELECT id FROM players WHERE name = 'Bhuvneshwar Kumar'), 4);
END $$;