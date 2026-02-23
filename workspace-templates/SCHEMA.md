# Supabase User Model Schema

This document tracks the intended schema for your SMind database in Supabase.

## Naming conventions
- `user_model_*` tables store interpretations of <YOUR_NAME>'s inputs (facts, constraints, events) extracted from chat/uploads.
- `smind_*` tables store artifacts produced/managed by the assistant (taxonomy/tags, schedules, assistant-generated goals, jobs, protocols).
- `user_data_*` tables store raw user-owned data (direct logs/history), not assistant inference.

## Tables

### `public.user_model_profile_as_items`
Profile/background context: habits, fears, values, beliefs, missions, preferences, history, etc.

- `key text primary key`
- `title text not null`
- `summary text null`
- `tags text[] not null default '{}'`
- `evidence jsonb not null default '[]'`

Constraints:
- `user_model_profile_as_items_evidence_is_array`: evidence must be a JSON array

Indexes:
- GIN on `tags`

#### Habits in Profile Items

Habits are stored as profile items with the `habits` tag. Scheduler may discover and manage habit-building strategies autonomously based on goals.

### `public.user_model_scheduling_constraints_and_preferences`
Future-applicable scheduling constraints and preferences parsed from the user (appointments, commitments, recurring patterns).

Assumption: all events are conditional in some way (exact dates, vague dates described in summary, recurring patterns described in text, or "only if X happens").

- `key text primary key`
- `title text not null`
- `summary text null`
- `starts_at timestamptz null`
- `ends_at timestamptz null`
- `timezone text null`
- `tags text[] not null default '{}'`
- `evidence jsonb not null default '[]'`

Constraints:
- `user_model_sched_constraints_evidence_is_array`: evidence must be a JSON array

Indexes:
- `starts_at`
- GIN on `tags`

### `public.smind_schedule_today`
Schedule for today as explicit time boxes (assistant-produced, updated nightly and after user wakes; can replan during chat).

- `key text primary key`
- `start_ts timestamptz not null`
- `end_ts timestamptz not null`
- `description text not null`

Constraints:
- `smind_schedule_today_time_order`: end_ts must be after start_ts

### `public.user_data_history`
Long-run history of all activities as explicit time boxes (raw user-owned data; spans many days/years).

- `key text primary key`
- `start_ts timestamptz not null`
- `end_ts timestamptz not null`
- `description text not null`
- `evidence jsonb not null default '[]'`

Constraints:
- `user_data_history_time_order`: end_ts must be after start_ts
- `user_data_history_evidence_is_array`: evidence must be a JSON array

### `public.smind_schedule_days`
Rolling schedule (one row per day). Rolling horizon is defined by the Scheduler worker job in `smind_society_core_jobs` (currently 100 days).

- `day_date date primary key`
- `description text not null`

**Inputs to Scheduler:**
- `smind_smart_goals` — goals to advance
- `user_model_scheduling_constraints_and_preferences` — hard constraints, recurring patterns
- `user_model_profile_as_items` — energy patterns, work style preferences

### `public.smind_smart_goals`
Goals derived from user model. Tracks desired outcomes and progress toward them.

- `key text primary key`
- `outcome text not null` — what you want to achieve
- `metric text` — what to measure (nullable if qualitative)
- `target text` — success threshold
- `current text` — last known state
- `status text not null default 'active'` — active | achieved | paused | dropped
- `evidence jsonb not null default '[]'` — links to user_model items that justify this goal

### `public.smind_society`
Registry of all Society members (currently all core infrastructure entities).

- `name text primary key` — entity name
- `description text not null` — purpose, artifacts, capabilities
- `type text not null default 'core'` — currently all `core`

Current core members (as of 2026-02-20):
- **Scientist** — produces schema-only benchmarks for data table quality (self-improving)
- **Evaluator** — grades actual data against benchmarks, manages GitHub issues
- **User Data Maintainer** — worker; addresses issues on user_model_*/user_data_* tables
- **Life Dimensions Locator** — worker; addresses issues on smind_life_dimensions
- **Smart Goal Creator** — worker; addresses issues on smind_smart_goals
- **Scheduler** — worker; addresses issues on smind_schedule_days
- **Face Data Gaps Assistant** — worker; addresses issues on smind_data_gap_questions
- **Face** — user-facing interaction layer (heartbeat-driven), delivers questions
- **Snapshot** — nightly database backup

### `public.smind_society_core_jobs`
Job definitions for core Society entities. Each row is a cron-runnable job belonging to a core entity.

- `job_name text primary key` — unique identifier for the job
- `enabled boolean not null default true` — whether the job can be run
- `instructions text null` — full prompt/instructions for the subroutine to follow (nullable in DB, but all rows currently populated)
- `member text` — FK → smind_society(name)

Constraints:
- `fk_society_member`: member references smind_society(name)

Current jobs (17 total, as of 2026-02-20): Pipeline is Scientist → Evaluator+UDM → Evaluator+LDL → Evaluator+SGC → Evaluator+Scheduler → Evaluator+FDGA.
- Scientist: 5 jobs (scientist_udm_benchmark, scientist_smart_goals_structural_benchmark, scientist_life_dimensions_benchmark, scientist_scheduling_benchmark, scientist_questions_benchmark)
- Evaluator: 5 jobs (evaluator_udm, evaluator_life_dimensions, evaluator_smart_goals, evaluator_scheduling, evaluator_questions)
- User Data Maintainer: 2 jobs (worker_udm, user_data_maintainer_integration_withings)
- Life Dimensions Locator: 1 job (worker_life_dimensions)
- Smart Goal Creator: 1 job (worker_smart_goals)
- Scheduler: 1 job (worker_scheduling)
- Face Data Gaps Assistant: 1 job (worker_questions)
- Snapshot: 1 job (database_snapshot)
- Face: 0 jobs — runs via main session heartbeat (HEARTBEAT.md), not cron

### `public.smind_life_dimensions`
Life dimensions taxonomy discovered autonomously by Life Dimensions Locator. Used by Smart Goal Creator to ensure goal coverage across all dimensions.

- `id text primary key` — dimension identifier (e.g., "health", "career")
- `name text not null` — human-readable dimension name
- `description text` — what this dimension covers

### `public.smind_hos_life_dimensions`
Higher-order structure (hOS) life dimensions. Predefined reference dimensions used by extended society entities. Not modified by core pipeline — serves as bias input for extended evaluators.

- `id text primary key` — dimension identifier
- `name text not null` — human-readable dimension name
- `description text` — what this dimension covers

### `public.smind_schedule_outcomes`
Historical record of suggested time boxes and their outcomes. Used for tracking which suggestions worked vs failed (RL feedback data).

- `key` text primary key
- `start_ts` timestamptz not null
- `end_ts` timestamptz not null
- `description` text not null
- `outcome` text null — what actually happened (completed / skipped / partial + notes)

Constraints:
- `smind_schedule_outcomes_time_order`: end_ts must be after start_ts

### `public.smind_data_gap_questions`
Questions for the user generated by the Face Data Gaps Assistant pipeline. Questions are deleted after being asked and responses are ingested into user_model via protocols.

- `key text primary key` — unique identifier
- `question_text text not null` — the question (with any options baked in)
- `priority text not null` — critical | high | medium | low
- `trigger_condition text` — when to ask (time-based, event-based, or protocol reference)
- `evidence jsonb not null default '[]'` — paths to .md files that prompted this question

Constraints:
- `user_model_sched_constraints_evidence_is_array` (**legacy misnomer** — constraint was copy-pasted from `user_model_scheduling_constraints_and_preferences`; should be renamed to `smind_data_gap_questions_evidence_is_array`): evidence must be a JSON array

## Triggers
- (none)

---
*Last verified: 2026-02-20 10:47 UTC*
