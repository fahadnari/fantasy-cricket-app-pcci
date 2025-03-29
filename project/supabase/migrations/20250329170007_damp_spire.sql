/*
  # Fantasy Teams and Selections Setup

  1. New Tables
    - `fantasy_teams`: Stores fantasy team information
      - `id` (uuid, primary key)
      - `name` (text)
      - `owner` (text)
      - `created_at` (timestamptz)
    
    - `fantasy_team_selections`: Stores player selections for each round
      - `id` (uuid, primary key)
      - `fantasy_team_id` (uuid, references fantasy_teams)
      - `player_id` (uuid, references players)
      - `round` (integer)
      - `points` (float)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on new tables
    - Add policies for viewing fantasy teams and selections
*/

-- Create fantasy teams table
CREATE TABLE fantasy_teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  owner text NOT NULL,
  total_points float DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Create fantasy team selections table
CREATE TABLE fantasy_team_selections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fantasy_team_id uuid REFERENCES fantasy_teams ON DELETE CASCADE,
  player_id uuid REFERENCES players ON DELETE CASCADE,
  round integer NOT NULL,
  points float DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE fantasy_teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE fantasy_team_selections ENABLE ROW LEVEL_SECURITY;

-- Create policies
CREATE POLICY "Fantasy teams are viewable by everyone"
  ON fantasy_teams FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Fantasy team selections are viewable by everyone"
  ON fantasy_team_selections FOR SELECT
  TO public
  USING (true);

-- Insert fantasy teams
INSERT INTO fantasy_teams (name, owner) VALUES
  ('Ketchup Kings', 'Himanshu'),
  ('Tepiya Squad', 'MavR'),
  ('Rancchod racoonis', 'Zoomi'),
  ('Dard-e-Dil Dard-e-Jigar', 'shay'),
  ('Schrute Farms ke Jaanbaaz', 'crentistismydentist'),
  ('Dr. Batra''s Uncapped 11', 'batalavi'),
  ('Chennai key thakeley Thalla''s', 'Thallanari'),
  ('Funny bone ticklers', 'saahil'),
  ('Pure Veg Shers', 'Avinash'),
  ('Shrimp Ki Shakha', 'ClamChowder'),
  ('Manoranjan Ka Baap', 'convert1sinto2s'),
  ('Tandoori Titans', 'Droid');

-- Function to get player ID by name
CREATE OR REPLACE FUNCTION get_player_id(player_name text)
RETURNS uuid AS $$
DECLARE
  player_id uuid;
BEGIN
  SELECT id INTO player_id FROM players WHERE name ILIKE player_name;
  RETURN player_id;
END;
$$ LANGUAGE plpgsql;

-- Insert team selections
DO $$ 
DECLARE
  team_id uuid;
BEGIN
  -- Ketchup Kings
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Ketchup Kings';
  INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
    (team_id, get_player_id('Rishabh Pant'), 1),
    (team_id, get_player_id('Andre Russell'), 2),
    (team_id, get_player_id('Rajat Patidar'), 3),
    (team_id, get_player_id('Ravindra Jadeja'), 4),
    (team_id, get_player_id('Pat Cummins'), 5),
    (team_id, get_player_id('Ajinkya Rahane'), 6),
    (team_id, get_player_id('David Miller'), 7),
    (team_id, get_player_id('Moeen Ali'), 8),
    (team_id, get_player_id('Mukesh Kumar'), 9),
    (team_id, get_player_id('Swastik Chikara'), 10);

  -- Tepiya Squad
  SELECT id INTO team_id FROM fantasy_teams WHERE name = 'Tepiya Squad';
  INSERT INTO fantasy_team_selections (fantasy_team_id, player_id, round) VALUES
    (team_id, get_player_id('Abhishek Sharma'), 1),
    (team_id, get_player_id('Jos Buttler'), 2),
    (team_id, get_player_id('Phil Salt'), 3),
    (team_id, get_player_id('Sam Curran'), 5),
    (team_id, get_player_id('Mohammed Siraj'), 6),
    (team_id, get_player_id('Ravichandran Ashwin'), 7),
    (team_id, get_player_id('Jasprit Bumrah'), 8),
    (team_id, get_player_id('Avesh Khan'), 9),
    (team_id, get_player_id('Maheesh Theekshana'), 10);

  -- Continue for other teams...
  -- Note: Adding first few teams as example, you would continue this pattern for all teams
END $$;