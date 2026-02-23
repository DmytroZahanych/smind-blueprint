# UDM Benchmark — User Data Model Quality Standard

> **Version:** 1.0.0
> **Last updated:** 2026-02-20
> **Scope:** `user_model_profile_as_items`, `user_model_scheduling_constraints_and_preferences`, `user_data_history`
> **Consumer:** Evaluator job (`evaluator_udm`) — an LLM that grades actual data against these criteria.

---

## How to Use This Benchmark

Each section defines a **quality dimension** with:
- **RULE**: A concrete, testable criterion.
- **PASS**: What compliance looks like.
- **FAIL**: What a violation looks like, with examples.
- **Severity**: `critical` | `high` | `medium` | `low` — guides issue priority.

The Evaluator should check every row in each table against every applicable rule and file GitHub issues for failures.

---

## 1. Schema Compliance

### 1.1 Primary Key Integrity
**RULE:** Every row must have a non-empty `key` (all three tables).
**PASS:** `key` is a non-empty string, unique within the table.
**FAIL:** `key` is null, empty string, or whitespace-only.
**Severity:** critical

### 1.2 Required Fields Non-Null
**RULE:** Required fields per schema must not be null or empty:
- `user_model_profile_as_items`: `title`
- `user_model_scheduling_constraints_and_preferences`: `title`
- `user_data_history`: `start_ts`, `end_ts`, `description`

**PASS:** All required fields are populated with meaningful content.
**FAIL:** Any required field is null, empty, or whitespace-only.
**Severity:** critical

### 1.3 Time Order Constraint (`user_data_history`)
**RULE:** `end_ts` must be strictly after `start_ts`.
**PASS:** `end_ts > start_ts` for every row.
**FAIL:** `end_ts <= start_ts`.
**Severity:** critical

### 1.4 Evidence Is Array
**RULE:** `evidence` column must be a JSON array (not null, not an object, not a string).
**PASS:** `evidence` parses as a JSON array (including empty `[]`).
**FAIL:** `evidence` is null, a bare string, a JSON object, or malformed JSON.
**Severity:** critical

### 1.5 Tags Is Array
**RULE:** `tags` column (on `user_model_profile_as_items` and `user_model_scheduling_constraints_and_preferences`) must be a text array.
**PASS:** `tags` is a valid Postgres text array (including empty `{}`).
**FAIL:** `tags` is null or contains null elements.
**Severity:** high

---

## 2. Key Quality

### 2.1 Key Format
**RULE:** Keys should be human-readable, snake_case or kebab-case identifiers that hint at the content. They serve as both primary key and semantic anchor.
**PASS:** `fear_of_flying`, `weekly-gym-routine`, `2025-01-15-dentist-appointment`
**FAIL:** `item_1`, `abc123`, `untitled`, `asdf`, UUIDs used as keys.
**Severity:** medium

### 2.2 Key Uniqueness Semantics
**RULE:** Two rows should not represent the same real-world fact, event, or activity. If they do, one should be deleted or they should be merged.
**PASS:** One row per distinct fact/event.
**FAIL:** `fear_of_flying` and `afraid_of_planes` both exist with overlapping content. Or `dentist_jan_2025` and `dentist_appointment_january` covering the same appointment.
**Severity:** high

### 2.3 Key Stability
**RULE:** Keys should not encode volatile information (e.g., current date in a key for a recurring event, sequence numbers that shift).
**PASS:** `weekly_cage_cleaning` for a recurring task.
**FAIL:** `weekly_cage_cleaning_2025_02_15` for a recurring pattern (date makes it seem one-time).
**Severity:** low

---

## 3. Content Quality

### 3.1 Title Clarity
**RULE:** `title` must be a concise, self-explanatory label. A reader should understand what the row is about from the title alone, without reading `summary`.
**PASS:** "Fear of flying", "Weekly gym routine — Mon/Wed/Fri", "Dentist appointment 2025-01-15"
**FAIL:** "Thing", "Note", "Important", "Untitled", "TODO"
**Severity:** high

### 3.2 Summary Informativeness
**RULE:** `summary` (when present) should add context beyond the title. It should contain specific details: dates, frequencies, conditions, quantities, context. If `summary` merely restates the `title`, it adds no value.
**PASS:** Title: "Fear of flying" → Summary: "the user experienced a scary turbulence event on a flight around 2018. Avoids flights when possible; prefers trains for European travel. Will fly if necessary but with significant anxiety."
**FAIL:** Title: "Fear of flying" → Summary: "the user is afraid of flying." (just restates title)
**Severity:** medium

### 3.3 Summary Accuracy (No Editorializing)
**RULE:** Summaries must faithfully represent what the user said. No positive spin, no softening of negative sentiment, no editorializing. Per the `no_glazing` protocol.
**PASS:** "Position is brittle and tenuous" if that's what the user said.
**FAIL:** "Navigating a dynamic career opportunity" when the user said their position is brittle.
**Severity:** high

### 3.4 Description Specificity (`user_data_history`)
**RULE:** `description` should describe what actually happened during the time box, with enough detail for a future reader to understand the activity.
**PASS:** "Worked on SMind society architecture — defined Evaluator job spec, wrote benchmark template"
**FAIL:** "Work", "Stuff", "Meeting"
**Severity:** medium

---

## 4. Table Assignment (Correct Routing)

### 4.1 Profile Items vs Scheduling Constraints
**RULE:** Data must be in the correct table per the extraction order in `on_message_ingest`:
- **`user_model_scheduling_constraints_and_preferences`**: Future-applicable constraints — appointments with dates, recurring patterns, commitments, conditional future constraints.
- **`user_model_profile_as_items`**: Stable background context — facts, preferences, habits, fears, traits, historical incidents that don't impose a future scheduling constraint.

**PASS:** "Dentist appointment on 2025-03-10" → scheduling constraints. "Has two parrots" → profile items.
**FAIL:** A dentist appointment stored in profile items. A personality trait stored in scheduling constraints.
**Severity:** high

### 4.2 Historical vs Future
**RULE:** Purely historical incidents that impose NO future constraint belong in `user_model_profile_as_items` (as background context), NOT in `user_model_scheduling_constraints_and_preferences`.
**PASS:** "Moved from Ukraine to Portugal in 2022" → profile item.
**FAIL:** "Moved from Ukraine to Portugal in 2022" → scheduling constraint (no future scheduling implication).
**Severity:** high

### 4.3 Profile Items vs User Data History
**RULE:** `user_data_history` stores time-boxed activity records (what happened in a specific time window). `user_model_profile_as_items` stores enduring facts/preferences. A specific gym session goes in history; the fact that the user exercises regularly goes in profile items.
**PASS:** "Gym session 2025-02-10 07:00–08:30" → user_data_history. "Exercises 3x/week, prefers morning sessions" → profile item.
**FAIL:** A general preference stored in user_data_history with fabricated timestamps. A specific dated event stored only as a profile item.
**Severity:** high

---

## 5. Timestamp Quality (Scheduling Constraints)

### 5.1 No Fabricated Precision
**RULE:** Per the timestamp policy in `on_message_ingest`, timestamps must not be more precise than what the user provided:
- Date without time → `starts_at` at midnight, summary says "time unknown"
- Year only → `starts_at = YYYY-01-01`, `ends_at = (YYYY+1)-01-01`, summary says "approximate"
- Month+year → `starts_at = YYYY-MM-01`, `ends_at = YYYY-(MM+1)-01`, summary says "approximate"

**PASS:** User said "sometime in March 2025" → `starts_at = 2025-03-01`, `ends_at = 2025-04-01`, summary: "approximate, March 2025"
**FAIL:** User said "sometime in March 2025" → `starts_at = 2025-03-15T10:00:00Z` (fabricated day and time).
**Severity:** high

### 5.2 Timezone Presence
**RULE:** If the user specified or implied a timezone, the `timezone` field should be populated. If not specified, it should default to the user's known timezone (Europe/Lisbon per USER.md) or be null with a note in summary.
**PASS:** `timezone: "Europe/Lisbon"` for a local appointment.
**FAIL:** `timezone: null` when the event is clearly local to the user.
**Severity:** medium

### 5.3 Recurring Events: Summary Describes Pattern
**RULE:** For recurring events, the recurrence pattern must be described in the `summary` field since there are no dedicated recurrence columns. The `starts_at`/`ends_at` fields may represent the first occurrence or be null, but the summary must clearly state the recurrence.
**PASS:** Summary: "Weekly gym session, Mon/Wed/Fri mornings. Started January 2025."
**FAIL:** A recurring event with `starts_at` for one occurrence and no mention of recurrence in summary.
**Severity:** high

### 5.4 Time Order for Scheduling Constraints
**RULE:** When both `starts_at` and `ends_at` are present, `ends_at` must be after `starts_at`.
**PASS:** `starts_at < ends_at`.
**FAIL:** `starts_at >= ends_at`.
**Severity:** critical

---

## 6. Evidence Quality

### 6.1 Evidence Present for Non-Obvious Facts
**RULE:** Every item or constraint derived from user conversation should have at least one evidence entry. The only exception is seed data or data so foundational it needs no citation (e.g., the user's name).
**PASS:** `evidence: [{"source": "file:/root/.openclaw/agents/main/sessions/abc123.jsonl#L42", "content": "I'm terrified of flying"}]`
**FAIL:** `evidence: []` for a specific claim like "allergic to shellfish" that must have come from somewhere.
**Severity:** high

### 6.2 Evidence Source Format
**RULE:** Per evidence source policy, the primary `source` field must point to OpenClaw session logs, not external chat message IDs:
- Format: `file:/root/.openclaw/agents/main/sessions/<sessionId>.jsonl#L<line>`
- External IDs (Telegram message_id, etc.) may appear in a secondary field like `legacy_source` but NOT as the primary `source`.

**PASS:** `{"source": "file:/root/.openclaw/agents/main/sessions/sess_abc.jsonl#L15", "content": "quoted text"}`
**FAIL:** `{"source": "telegram:msg_12345"}` as the only source.
**Severity:** high

### 6.3 Evidence Content Field
**RULE:** Each evidence entry should include a `content` field with a direct quote or snippet from the user's message. This makes evidence self-contained — readable without chasing the source file.
**PASS:** `{"source": "...", "content": "I usually go to the gym Mon, Wed, and Fri mornings"}`
**FAIL:** `{"source": "..."}` with no `content` field, or `{"content": "user mentioned gym"}` (paraphrase, not quote).
**Severity:** medium

### 6.4 Evidence Freshness
**RULE:** Evidence should reference real, existing session files. Fabricated session IDs or line numbers are worse than no evidence.
**PASS:** The session file referenced actually exists (Evaluator may spot-check).
**FAIL:** A session ID that follows no known pattern or references a clearly nonexistent file.
**Severity:** high

---

## 7. Tags Quality

### 7.1 Tags Are Meaningful
**RULE:** Tags should be drawn from a coherent taxonomy and provide useful categorization. They should be lowercase, use consistent naming (snake_case or single words).
**PASS:** `{habits, health, fitness}`, `{travel, preferences}`, `{work, career}`
**FAIL:** `{misc}`, `{tag1}`, `{important}`, `{}` on a row that clearly belongs to a category.
**Severity:** medium

### 7.2 No Tag Proliferation
**RULE:** Tags should converge on a manageable set rather than spawning unique tags per item. If the tag set grows beyond ~30 distinct tags across all items, there's likely duplication or over-specificity.
**PASS:** Consistent reuse of tags like `health`, `career`, `family`, `finance`, `travel`.
**FAIL:** 50+ unique tags with many used only once, like `dentist_2025`, `that_flight_thing`.
**Severity:** low

### 7.3 Habits Tag Convention
**RULE:** Per SCHEMA.md, habits are stored as profile items with the `habits` tag. Any habit-related item must include `habits` in its tags array.
**PASS:** "Morning gym routine" with tags `{habits, fitness, health}`.
**FAIL:** "Morning gym routine" with tags `{fitness, health}` but missing `habits`.
**Severity:** medium

---

## 8. Cross-Table Consistency

### 8.1 No Orphaned References
**RULE:** If a profile item references a scheduling constraint (or vice versa) by key, that referenced key must exist.
**PASS:** Profile item summary says "see also: weekly_gym_routine" and that key exists in scheduling constraints.
**FAIL:** Reference to a key that doesn't exist in any table.
**Severity:** medium

### 8.2 No Contradictions Between Tables
**RULE:** Information in profile items should not contradict information in scheduling constraints or user_data_history. If the user changed their mind, the old entry should be updated or removed.
**PASS:** Profile says "exercises 3x/week" and scheduling has a matching recurring constraint.
**FAIL:** Profile says "doesn't exercise" but scheduling has active gym appointments.
**Severity:** high

### 8.3 History Aligns with Constraints
**RULE:** `user_data_history` entries for recurring activities should be consistent with any recurring patterns described in scheduling constraints. Occasional misses are fine (life happens), but systematic divergence suggests stale data.
**PASS:** Scheduling says "gym Mon/Wed/Fri" and history shows gym entries roughly matching that pattern.
**FAIL:** Scheduling says "daily meditation 6am" but history has zero meditation entries over months. (Constraint may be aspirational rather than actual — should be flagged for review.)
**Severity:** low

---

## 9. Data Hygiene

### 9.1 No Stale Scheduling Constraints
**RULE:** One-time scheduling constraints whose date has passed should either be removed or moved to `user_data_history` (if the activity actually happened). A scheduling constraint for "dentist on 2024-06-15" still present in February 2026 is stale.
**PASS:** Past one-time events cleaned up; only future/recurring constraints remain.
**FAIL:** Multiple past-dated one-time constraints still in the table.
**Severity:** medium

### 9.2 No Duplicate Content
**RULE:** Two rows should not express the same fact, even with different keys. This applies within each table and across tables (per section 4 routing rules).
**PASS:** One authoritative row per fact.
**FAIL:** `fear_of_flying` and `flight_anxiety` both describing the same fear with overlapping content.
**Severity:** high

### 9.3 No Empty/Placeholder Rows
**RULE:** Every row should contain real, meaningful data. No placeholder entries, test data, or rows with only a key and defaults.
**PASS:** Every row has substantive content in title/summary/description.
**FAIL:** A row with `title: "test"`, `summary: null`, `tags: {}`, `evidence: []`.
**Severity:** high

---

## 10. Completeness Indicators

> These are NOT hard failures — they are signals for the Evaluator to flag as potential data gaps (which may feed into `smind_data_gap_questions`). The Evaluator should note these but at lower severity.

### 10.1 Life Dimension Coverage
**RULE:** The user model should have at least some items covering major life dimensions: health, career/work, relationships/family, finance, personal development, living situation. Absence of an entire dimension suggests data gaps.
**Severity:** low (informational)

### 10.2 Evidence Coverage Ratio
**RULE:** The percentage of items with non-empty evidence should be tracked. A ratio below 50% suggests systematic evidence omission.
**Severity:** low (informational)

### 10.3 Recency
**RULE:** If all items have evidence pointing to sessions older than 90 days and no recent updates, the model may be going stale.
**Severity:** low (informational)

---

## Appendix A: Evaluation Procedure for Evaluator Job

When evaluating, the Evaluator should:

1. **Scan all rows** in each of the three tables.
2. **Check each row** against all applicable rules from this benchmark.
3. **Group failures** by rule, not by row — one GitHub issue per rule violation pattern, listing all affected rows.
4. **Set issue priority** based on the severity of the violated rule.
5. **Include actionable fix descriptions** — what specifically should change (e.g., "merge rows X and Y", "add evidence to row Z", "move row W from profile to scheduling").
6. **Do NOT modify data** — only file issues. The User Data Maintainer worker handles fixes.

## Appendix B: Severity Mapping to GitHub Issue Labels

| Severity | GitHub Label | Expected Response Time |
|----------|-------------|----------------------|
| critical | `priority: critical` | Must fix before next pipeline run |
| high | `priority: high` | Fix within 1-2 pipeline cycles |
| medium | `priority: medium` | Fix when convenient |
| low | `priority: low` | Nice to have / informational |

---

*This benchmark is self-improving. Each run of the Scientist job should review and enhance it.*
