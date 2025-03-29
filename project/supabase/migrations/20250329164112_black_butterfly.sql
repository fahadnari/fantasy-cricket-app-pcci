/*
  # Add IPL 2025 Players

  1. Changes
    - Insert player data for IPL 2025 season
    - Players from all teams with their roles
*/

INSERT INTO players (name, team, role) VALUES
  -- Chennai Super Kings
  ('MS Dhoni', 'Chennai Super Kings', 'Wicket Keeper'),
  ('Ravindra Jadeja', 'Chennai Super Kings', 'All-rounder'),
  ('Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman'),
  ('Deepak Chahar', 'Chennai Super Kings', 'Bowler'),
  ('Ajinkya Rahane', 'Chennai Super Kings', 'Batsman'),

  -- Mumbai Indians
  ('Hardik Pandya', 'Mumbai Indians', 'All-rounder'),
  ('Rohit Sharma', 'Mumbai Indians', 'Batsman'),
  ('Jasprit Bumrah', 'Mumbai Indians', 'Bowler'),
  ('Suryakumar Yadav', 'Mumbai Indians', 'Batsman'),
  ('Ishan Kishan', 'Mumbai Indians', 'Wicket Keeper'),

  -- Royal Challengers Bangalore
  ('Virat Kohli', 'Royal Challengers Bangalore', 'Batsman'),
  ('Glenn Maxwell', 'Royal Challengers Bangalore', 'All-rounder'),
  ('Mohammed Siraj', 'Royal Challengers Bangalore', 'Bowler'),
  ('Faf du Plessis', 'Royal Challengers Bangalore', 'Batsman'),
  ('Dinesh Karthik', 'Royal Challengers Bangalore', 'Wicket Keeper'),

  -- Kolkata Knight Riders
  ('Shreyas Iyer', 'Kolkata Knight Riders', 'Batsman'),
  ('Andre Russell', 'Kolkata Knight Riders', 'All-rounder'),
  ('Sunil Narine', 'Kolkata Knight Riders', 'All-rounder'),
  ('Venkatesh Iyer', 'Kolkata Knight Riders', 'All-rounder'),
  ('Mitchell Starc', 'Kolkata Knight Riders', 'Bowler'),

  -- Delhi Capitals
  ('Rishabh Pant', 'Delhi Capitals', 'Wicket Keeper'),
  ('David Warner', 'Delhi Capitals', 'Batsman'),
  ('Mitchell Marsh', 'Delhi Capitals', 'All-rounder'),
  ('Axar Patel', 'Delhi Capitals', 'All-rounder'),
  ('Kuldeep Yadav', 'Delhi Capitals', 'Bowler'),

  -- Rajasthan Royals
  ('Sanju Samson', 'Rajasthan Royals', 'Wicket Keeper'),
  ('Jos Buttler', 'Rajasthan Royals', 'Wicket Keeper'),
  ('Trent Boult', 'Rajasthan Royals', 'Bowler'),
  ('Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman'),
  ('Ravichandran Ashwin', 'Rajasthan Royals', 'All-rounder'),

  -- Punjab Kings
  ('Shikhar Dhawan', 'Punjab Kings', 'Batsman'),
  ('Sam Curran', 'Punjab Kings', 'All-rounder'),
  ('Kagiso Rabada', 'Punjab Kings', 'Bowler'),
  ('Liam Livingstone', 'Punjab Kings', 'All-rounder'),
  ('Jitesh Sharma', 'Punjab Kings', 'Wicket Keeper'),

  -- Sunrisers Hyderabad
  ('Pat Cummins', 'Sunrisers Hyderabad', 'All-rounder'),
  ('Travis Head', 'Sunrisers Hyderabad', 'Batsman'),
  ('Bhuvneshwar Kumar', 'Sunrisers Hyderabad', 'Bowler'),
  ('Heinrich Klaasen', 'Sunrisers Hyderabad', 'Wicket Keeper'),
  ('Mayank Agarwal', 'Sunrisers Hyderabad', 'Batsman'),

  -- Gujarat Titans
  ('Shubman Gill', 'Gujarat Titans', 'Batsman'),
  ('Rashid Khan', 'Gujarat Titans', 'All-rounder'),
  ('Mohammed Shami', 'Gujarat Titans', 'Bowler'),
  ('Kane Williamson', 'Gujarat Titans', 'Batsman'),
  ('Wriddhiman Saha', 'Gujarat Titans', 'Wicket Keeper'),

  -- Lucknow Super Giants
  ('KL Rahul', 'Lucknow Super Giants', 'Wicket Keeper'),
  ('Marcus Stoinis', 'Lucknow Super Giants', 'All-rounder'),
  ('Quinton de Kock', 'Lucknow Super Giants', 'Wicket Keeper'),
  ('Ravi Bishnoi', 'Lucknow Super Giants', 'Bowler'),
  ('Nicholas Pooran', 'Lucknow Super Giants', 'Wicket Keeper')
ON CONFLICT DO NOTHING;