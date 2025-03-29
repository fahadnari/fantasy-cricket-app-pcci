/*
  # Fantasy Cricket Database Schema

  1. New Tables
    - `players`: Stores IPL player information
      - `id` (uuid, primary key)
      - `name` (text)
      - `team` (text)
      - `role` (text)
      
    - `user_teams`: Stores user-created teams
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `team_name` (text)
      - `created_at` (timestamptz)
      
    - `team_players`: Junction table for user teams and players
      - `team_id` (uuid, references user_teams)
      - `player_id` (uuid, references players)
      
    - `match_performances`: Stores player performance in each match
      - `id` (uuid, primary key)
      - `player_id` (uuid, references players)
      - `match_date` (date)
      - `sixes` (int)
      - `fours` (int)
      - `wickets` (int)
      - `catches` (int)
      - `stumpings` (int)
      - `run_outs` (int)
      - `points` (float)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Create players table
CREATE TABLE players (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  team text NOT NULL,
  role text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create user_teams table
CREATE TABLE user_teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  team_name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create team_players junction table
CREATE TABLE team_players (
  team_id uuid REFERENCES user_teams ON DELETE CASCADE,
  player_id uuid REFERENCES players ON DELETE CASCADE,
  PRIMARY KEY (team_id, player_id)
);

-- Create match_performances table
CREATE TABLE match_performances (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id uuid REFERENCES players ON DELETE CASCADE,
  match_date date NOT NULL,
  sixes int DEFAULT 0,
  fours int DEFAULT 0,
  wickets int DEFAULT 0,
  catches int DEFAULT 0,
  stumpings int DEFAULT 0,
  run_outs int DEFAULT 0,
  points float DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_performances ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Players are viewable by everyone"
  ON players FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can create and manage their own teams"
  ON user_teams FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Team players are viewable by team owners"
  ON team_players FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_teams
      WHERE id = team_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Match performances are viewable by everyone"
  ON match_performances FOR SELECT
  TO public
  USING (true);

-- Create function to calculate points
CREATE OR REPLACE FUNCTION calculate_match_points()
RETURNS TRIGGER AS $$
BEGIN
  NEW.points = (
    NEW.sixes * 3.5 +
    NEW.fours * 2.5 +
    NEW.wickets * 3.5 +
    (NEW.catches + NEW.stumpings + NEW.run_outs) * 2.5
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically calculate points
CREATE TRIGGER calculate_points_trigger
  BEFORE INSERT OR UPDATE ON match_performances
  FOR EACH ROW
  EXECUTE FUNCTION calculate_match_points();