/*
  # Create Fitness Tracker Schema

  1. New Tables
    - `workouts`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `name` (text)
      - `date` (date)
      - `notes` (text)
      - `created_at` (timestamp)
    
    - `exercises`
      - `id` (uuid, primary key)
      - `workout_id` (uuid, references workouts)
      - `name` (text)
      - `sets` (integer)
      - `reps` (integer)
      - `weight` (numeric)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users to manage their own data
*/

-- Create workouts table
CREATE TABLE workouts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  name text NOT NULL,
  date date NOT NULL DEFAULT CURRENT_DATE,
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Create exercises table
CREATE TABLE exercises (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workout_id uuid REFERENCES workouts ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  sets integer NOT NULL,
  reps integer NOT NULL,
  weight numeric,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;

-- Create policies for workouts
CREATE POLICY "Users can create their own workouts"
  ON workouts
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own workouts"
  ON workouts
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own workouts"
  ON workouts
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own workouts"
  ON workouts
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create policies for exercises
CREATE POLICY "Users can manage exercises for their workouts"
  ON exercises
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM workouts
      WHERE workouts.id = exercises.workout_id
      AND workouts.user_id = auth.uid()
    )
  );