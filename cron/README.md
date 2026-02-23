# Cron Jobs

The SMind society pipeline runs on a nightly cycle. Below are the recommended cron jobs.

## Pipeline Order

The jobs should run in sequence (each ~30 min apart to allow completion):

1. **Scientist** (5 jobs) — produces/updates benchmarks
2. **Evaluator** (5 jobs) — grades data vs benchmarks, opens GitHub issues
3. **Workers** (5 jobs) — address GitHub issues
4. **Snapshot** — backup database

## Recommended Schedule

All times in your local timezone. Adjust to fit your quiet hours.

| Order | Job Name | Cron | Session |
|-------|----------|------|---------|
| 1 | scientist_udm_benchmark | `0 23 * * *` | isolated |
| 2 | scientist_life_dimensions_benchmark | `10 23 * * *` | isolated |
| 3 | scientist_smart_goals_structural_benchmark | `20 23 * * *` | isolated |
| 4 | scientist_scheduling_benchmark | `30 23 * * *` | isolated |
| 5 | scientist_questions_benchmark | `40 23 * * *` | isolated |
| 6 | evaluator_udm | `0 0 * * *` | isolated |
| 7 | evaluator_life_dimensions | `15 0 * * *` | isolated |
| 8 | evaluator_smart_goals | `30 0 * * *` | isolated |
| 9 | evaluator_scheduling | `45 0 * * *` | isolated |
| 10 | evaluator_questions | `0 1 * * *` | isolated |
| 11 | worker_udm | `30 1 * * *` | isolated |
| 12 | worker_life_dimensions | `0 2 * * *` | isolated |
| 13 | worker_smart_goals | `30 2 * * *` | isolated |
| 14 | worker_scheduling | `0 3 * * *` | isolated |
| 15 | worker_questions | `30 3 * * *` | isolated |
| 16 | database_snapshot (pre-cycle) | `30 22 * * *` | isolated |
| 17 | database_snapshot (post-cycle) | `30 6 * * *` | isolated |

## Job Payload Format

All society jobs use this pattern:

```json
{
  "kind": "agentTurn",
  "message": "Fetch your instructions from Supabase table `smind_society_core_jobs` where job_name='<JOB_NAME>'. Execute those instructions exactly.",
  "timeoutSeconds": 300
}
```

## Creating Jobs

Use OpenClaw's cron system. Example for each job:

```
/cron add --name "scientist_udm_benchmark" \
  --schedule '{"kind":"cron","expr":"0 23 * * *","tz":"<YOUR_TIMEZONE>"}' \
  --sessionTarget isolated \
  --payload '{"kind":"agentTurn","message":"Fetch your instructions from Supabase table smind_society_core_jobs where job_name='\''scientist_udm_benchmark'\''. Execute those instructions exactly.","timeoutSeconds":300}'
```

Or use the `cron` tool programmatically from within OpenClaw.

## Face (No Cron Job)

Face runs via the main session heartbeat, not cron. Its behavior is defined in `HEARTBEAT.md`.
