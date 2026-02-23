-- SMind Blueprint: Supabase Migration
-- Safe to run on both fresh and existing projects (uses IF NOT EXISTS).
-- NOTE: IF NOT EXISTS won't modify existing tables — if columns differ
-- from what's defined here, you'll need to ALTER TABLE manually.
-- Compare with SCHEMA.md for the intended schema.

-- ============================================================
-- exec_sql RPC (used by supabase skill for arbitrary queries)
-- ============================================================
CREATE OR REPLACE FUNCTION public.exec_sql(query text)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result json;
BEGIN
  EXECUTE query INTO result;
  RETURN result;
END;
$$;

-- ============================================================
-- User Model Tables
-- ============================================================

CREATE TABLE IF NOT EXISTS public.user_model_profile_as_items (
  key text PRIMARY KEY,
  title text NOT NULL,
  summary text,
  tags text[] NOT NULL DEFAULT '{}',
  evidence jsonb NOT NULL DEFAULT '[]',
  CONSTRAINT user_model_profile_as_items_evidence_is_array CHECK (jsonb_typeof(evidence) = 'array')
);
CREATE INDEX IF NOT EXISTS idx_user_model_profile_tags ON public.user_model_profile_as_items USING gin(tags);

CREATE TABLE IF NOT EXISTS public.user_model_scheduling_constraints_and_preferences (
  key text PRIMARY KEY,
  title text NOT NULL,
  summary text,
  starts_at timestamptz,
  ends_at timestamptz,
  timezone text,
  tags text[] NOT NULL DEFAULT '{}',
  evidence jsonb NOT NULL DEFAULT '[]',
  CONSTRAINT user_model_sched_constraints_evidence_is_array CHECK (jsonb_typeof(evidence) = 'array')
);
CREATE INDEX IF NOT EXISTS idx_sched_starts ON public.user_model_scheduling_constraints_and_preferences(starts_at);
CREATE INDEX IF NOT EXISTS idx_sched_tags ON public.user_model_scheduling_constraints_and_preferences USING gin(tags);

-- ============================================================
-- User Data Tables
-- ============================================================

CREATE TABLE IF NOT EXISTS public.user_data_history (
  key text PRIMARY KEY,
  start_ts timestamptz NOT NULL,
  end_ts timestamptz NOT NULL,
  description text NOT NULL,
  evidence jsonb NOT NULL DEFAULT '[]',
  CONSTRAINT user_data_history_time_order CHECK (end_ts > start_ts),
  CONSTRAINT user_data_history_evidence_is_array CHECK (jsonb_typeof(evidence) = 'array')
);

-- ============================================================
-- Schedule Tables
-- ============================================================

CREATE TABLE IF NOT EXISTS public.smind_schedule_today (
  key text PRIMARY KEY,
  start_ts timestamptz NOT NULL,
  end_ts timestamptz NOT NULL,
  description text NOT NULL,
  CONSTRAINT smind_schedule_today_time_order CHECK (end_ts > start_ts)
);

CREATE TABLE IF NOT EXISTS public.smind_schedule_days (
  day_date date PRIMARY KEY,
  description text NOT NULL
);

CREATE TABLE IF NOT EXISTS public.smind_schedule_outcomes (
  key text PRIMARY KEY,
  start_ts timestamptz NOT NULL,
  end_ts timestamptz NOT NULL,
  description text NOT NULL,
  outcome text,
  CONSTRAINT smind_schedule_outcomes_time_order CHECK (end_ts > start_ts)
);

-- ============================================================
-- Society Tables
-- ============================================================

CREATE TABLE IF NOT EXISTS public.smind_society (
  name text PRIMARY KEY,
  description text NOT NULL,
  type text NOT NULL DEFAULT 'core'
);

CREATE TABLE IF NOT EXISTS public.smind_society_core_jobs (
  job_name text PRIMARY KEY,
  enabled boolean NOT NULL DEFAULT true,
  instructions text,
  member text,
  CONSTRAINT fk_society_member FOREIGN KEY (member) REFERENCES public.smind_society(name)
);

-- ============================================================
-- Goals & Dimensions Tables
-- ============================================================

CREATE TABLE IF NOT EXISTS public.smind_smart_goals (
  key text PRIMARY KEY,
  outcome text NOT NULL,
  metric text,
  target text,
  current text,
  status text NOT NULL DEFAULT 'active',
  evidence jsonb NOT NULL DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS public.smind_life_dimensions (
  id text PRIMARY KEY,
  name text NOT NULL,
  description text
);

CREATE TABLE IF NOT EXISTS public.smind_hos_life_dimensions (
  id text PRIMARY KEY,
  name text NOT NULL,
  description text
);

-- ============================================================
-- Data Gap Questions
-- ============================================================

CREATE TABLE IF NOT EXISTS public.smind_data_gap_questions (
  key text PRIMARY KEY,
  question_text text NOT NULL,
  priority text NOT NULL,
  trigger_condition text,
  evidence jsonb NOT NULL DEFAULT '[]',
  CONSTRAINT smind_data_gap_questions_evidence_is_array CHECK (jsonb_typeof(evidence) = 'array')
);

-- ============================================================
-- Extended Society Table
-- ============================================================

CREATE TABLE IF NOT EXISTS public.smind_society_extended (
  job_name text PRIMARY KEY,
  enabled boolean NOT NULL DEFAULT true,
  instructions text,
  member text NOT NULL
);

-- ============================================================
-- Seed Data: hOS Life Dimensions
-- ============================================================

INSERT INTO public.smind_hos_life_dimensions (id, name, description) VALUES
  ('health', 'Health', 'Physical and mental wellbeing, medical care, longevity, and all aspects of bodily health.'),
  ('finances', 'Finances', 'Financial stability, income, budgeting, taxes, and wealth management.'),
  ('career', 'Career', 'Professional development, work satisfaction, skills, and career trajectory.'),
  ('relationships', 'Relationships', 'Interpersonal connections — partner, family, friends, social life, and dependents including pets.'),
  ('spirituality', 'Spirituality', 'Meaning, purpose, inner life, values, and philosophical grounding.'),
  ('enjoyment', 'Enjoyment', 'Leisure, hobbies, fun, creativity, and experiences that bring joy.'),
  ('impact', 'Impact', 'Contribution to others, community, legacy, and making a difference beyond oneself.')
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- Seed Data: Extended Society Members
-- ============================================================

INSERT INTO public.smind_society (name, description, type) VALUES
  ('Health Life Dimension Agent', 'Defines what comprehensive life dimension coverage looks like for physical/mental health, medical care, and longevity. Evaluates smind_life_dimensions for gaps in health-related dimension coverage.', 'extended'),
  ('Finances Life Dimension Agent', 'Defines what comprehensive life dimension coverage looks like for financial stability, income, budgeting, and wealth. Evaluates smind_life_dimensions for gaps in finance-related dimension coverage.', 'extended'),
  ('Career Life Dimension Agent', 'Defines what comprehensive life dimension coverage looks like for professional development, work satisfaction, and career trajectory. Evaluates smind_life_dimensions for gaps in career-related dimension coverage.', 'extended'),
  ('Relationships Life Dimension Agent', 'Defines what comprehensive life dimension coverage looks like for interpersonal connections — partner, family, friends, social life, and dependents. Evaluates smind_life_dimensions for gaps in relationship-related dimension coverage.', 'extended'),
  ('Spirituality Life Dimension Agent', 'Defines what comprehensive life dimension coverage looks like for meaning, purpose, inner life, values, and philosophical grounding. Evaluates smind_life_dimensions for gaps in spirituality-related dimension coverage.', 'extended'),
  ('Enjoyment Life Dimension Agent', 'Defines what comprehensive life dimension coverage looks like for leisure, hobbies, creativity, and experiences that bring joy. Evaluates smind_life_dimensions for gaps in enjoyment-related dimension coverage.', 'extended'),
  ('Impact Life Dimension Agent', 'Defines what comprehensive life dimension coverage looks like for contribution to others, community, legacy, and making a difference. Evaluates smind_life_dimensions for gaps in impact-related dimension coverage.', 'extended')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- Seed Data: Extended Society Jobs
-- Note: Job instructions are long prompts. They are inserted here
-- so new installs get the full extended pipeline out of the box.
-- Instructions can be updated later via the society pipeline.
-- ============================================================

-- Instructions are inserted via seed-extended-jobs.sql (separate file)
-- to keep this migration readable. Run it after this migration.

-- ============================================================
-- Enable Row Level Security (optional but recommended)
-- For a single-user setup, you can use service key and skip RLS.
-- ============================================================

-- Done! All tables created.
