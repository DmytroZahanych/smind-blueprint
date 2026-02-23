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
-- Enable Row Level Security (optional but recommended)
-- For a single-user setup, you can use service key and skip RLS.
-- ============================================================

-- Done! All tables created.
