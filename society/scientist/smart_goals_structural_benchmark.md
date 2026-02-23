# SMART Goals Structural Benchmark — Schema & Methodology Quality Standard

> **Version:** 1.0.0
> **Last updated:** 2026-02-20
> **Scope:** `smind_smart_goals`
> **Consumer:** Evaluator job (`evaluator_smart_goals`) — an LLM that grades actual data against these criteria.

---

## How to Use This Benchmark

Each section defines a **quality dimension** with:
- **RULE**: A concrete, testable criterion.
- **PASS**: What compliance looks like.
- **FAIL**: What a violation looks like, with examples.
- **Severity**: `critical` | `high` | `medium` | `low` — guides issue priority.

The Evaluator should check every row in `smind_smart_goals` against every applicable rule and file GitHub issues for failures.

---

## 1. Schema Compliance

### 1.1 Primary Key Integrity
**RULE:** Every row must have a non-empty `key`.
**PASS:** `key` is a non-empty, unique string.
**FAIL:** `key` is null, empty, or whitespace-only.
**Severity:** critical

### 1.2 Outcome Non-Null
**RULE:** `outcome` (NOT NULL in schema) must contain a meaningful statement of the desired result.
**PASS:** `outcome` is a non-empty string describing what the user wants to achieve.
**FAIL:** `outcome` is empty, whitespace-only, or a placeholder like "TBD".
**Severity:** critical

### 1.3 Status Value Validity
**RULE:** `status` must be one of the defined enum values: `active`, `achieved`, `paused`, `dropped`.
**PASS:** `status = 'active'`
**FAIL:** `status = 'pending'`, `status = 'in_progress'`, or any value outside the enum.
**Severity:** critical

### 1.4 Evidence Is Array
**RULE:** `evidence` must be a JSON array.
**PASS:** `evidence` parses as a JSON array (including empty `[]`).
**FAIL:** `evidence` is null, a bare string, a JSON object, or malformed JSON.
**Severity:** critical

---

## 2. Key Quality

### 2.1 Key Format
**RULE:** Keys should be human-readable, snake_case or kebab-case identifiers that semantically describe the goal.
**PASS:** `improve_cardiovascular_fitness`, `learn-portuguese-b2`, `build_emergency_fund`
**FAIL:** `goal_1`, `abc123`, `untitled`, UUIDs.
**Severity:** medium

### 2.2 Key Uniqueness Semantics
**RULE:** Two rows must not represent the same real-world goal. If they do, one should be deleted or they should be merged.
**PASS:** One row per distinct goal.
**FAIL:** `learn_portuguese` and `portuguese_fluency` both covering the same language goal with overlapping content.
**Severity:** high

---

## 3. SMART Criteria — Specific

### 3.1 Outcome Specificity
**RULE:** `outcome` must describe a concrete, well-defined result — not a vague aspiration. It should be clear enough that two independent readers would agree on what "done" looks like.
**PASS:** "Achieve Portuguese B2 conversational fluency (able to hold a 30-min conversation with a native speaker on everyday topics)"
**FAIL:** "Get better at Portuguese", "Improve health", "Be more productive"
**Severity:** high

### 3.2 Outcome Is an Outcome, Not an Activity
**RULE:** `outcome` must describe a desired end-state, not an ongoing activity or process.
**PASS:** "Run a half-marathon in under 2 hours"
**FAIL:** "Go running more often", "Keep exercising"
**Severity:** high

---

## 4. SMART Criteria — Measurable

### 4.1 Metric Presence
**RULE:** `metric` should be populated for any goal where progress can be quantified. It may be null only for genuinely qualitative goals where no meaningful metric exists.
**PASS:** `metric = 'weekly running distance (km)'` for a fitness goal. `metric = null` for "establish a consistent morning routine" (qualitative habit).
**FAIL:** `metric = null` for "save €10,000" (clearly quantifiable). `metric = 'progress'` (non-specific).
**Severity:** high

### 4.2 Metric Clarity
**RULE:** When present, `metric` must name a specific, observable quantity or indicator — including units or scale where applicable.
**PASS:** `metric = 'body weight (kg)'`, `metric = 'savings balance (EUR)'`, `metric = 'Portuguese vocabulary size (words)'`
**FAIL:** `metric = 'fitness level'`, `metric = 'amount'`, `metric = 'how much'`
**Severity:** high

### 4.3 Target Presence When Metric Exists
**RULE:** If `metric` is populated, `target` should also be populated to define the success threshold.
**PASS:** `metric = 'savings balance (EUR)'`, `target = '10000'`
**FAIL:** `metric = 'savings balance (EUR)'`, `target = null` — measurable but no defined finish line.
**Severity:** high

### 4.4 Target Specificity
**RULE:** `target` must state a concrete threshold — a number, date, level, or binary state — not a relative or vague improvement.
**PASS:** `target = '10000 EUR'`, `target = 'B2 certification'`, `target = 'sub-2:00 half marathon'`
**FAIL:** `target = 'more'`, `target = 'better'`, `target = 'significant improvement'`
**Severity:** high

---

## 5. SMART Criteria — Achievable

### 5.1 No Logically Impossible Goals
**RULE:** The goal must not be internally contradictory or physically impossible as stated. (Note: the Evaluator is NOT judging whether the goal is realistic for the specific user — only whether the goal statement is coherent.)
**PASS:** Any goal that is logically and physically possible to achieve.
**FAIL:** A goal whose outcome and metric/target contradict each other, or that describes something impossible by definition.
**Severity:** medium

### 5.2 Goal Granularity
**RULE:** Goals should be at a level of granularity that can be meaningfully tracked and advanced by the Scheduler. A goal so broad it encompasses an entire life domain is too coarse; a goal so narrow it's a single task is too fine.
**PASS:** "Achieve conversational Portuguese B2" (clear scope, multi-month effort, trackable)
**FAIL:** "Live a perfect life" (too broad). "Buy groceries on Tuesday" (too narrow — this is a task, not a goal).
**Severity:** medium

---

## 6. SMART Criteria — Relevant

### 6.1 Evidence Links to User Model
**RULE:** Each goal should have evidence linking it back to the user model (`user_model_profile_as_items` or `user_model_scheduling_constraints_and_preferences`). Goals must be grounded in expressed user needs, values, or circumstances — not invented by the system.
**PASS:** `evidence: [{"source": "user_model_profile_as_items:fear_of_flying", "content": "User wants to overcome flight anxiety"}]`
**FAIL:** `evidence: []` on a goal with no obvious connection to known user context. A goal that appears fabricated with no user-model backing.
**Severity:** high

### 6.2 Evidence Content Quality
**RULE:** Evidence entries should include a `content` field summarizing why this goal is relevant to the user — a brief justification trace.
**PASS:** `{"source": "user_model_profile_as_items:career_software_engineer", "content": "User wants to advance career; improving system design skills aligns with stated growth area"}`
**FAIL:** `{"source": "user_model_profile_as_items:career_software_engineer"}` with no `content` field.
**Severity:** medium

### 6.3 Life Dimension Linkage
**RULE:** Every goal should map to at least one life dimension in `smind_life_dimensions`. While the `smind_smart_goals` schema does not have a dimension FK column, the evidence or key naming should make the dimension affiliation clear.
**PASS:** Key `improve_cardiovascular_fitness` clearly maps to a health dimension; evidence references health-related profile items.
**FAIL:** A goal with no discernible connection to any life dimension — floating in a vacuum.
**Severity:** medium

---

## 7. SMART Criteria — Time-bound

> The current `smind_smart_goals` schema does not have explicit deadline columns. Time-bounding must therefore be expressed within `outcome`, `target`, or `metric` text fields.

### 7.1 Temporal Anchor Present
**RULE:** Goals should include a time reference — either a deadline, a time horizon, or a cadence — somewhere in `outcome` or `target`. Open-ended goals with no temporal dimension are structurally incomplete.
**PASS:** `outcome = 'Save €10,000 emergency fund by end of 2026'`, `target = '10000 EUR by 2026-12-31'`
**FAIL:** `outcome = 'Save money'`, `target = '10000 EUR'` with no time reference anywhere in the row.
**Severity:** high

### 7.2 Temporal Anchor Specificity
**RULE:** Time references should be specific enough to enable scheduling. "Soon" or "eventually" are not time-bounds.
**PASS:** "by Q3 2026", "within 6 months", "by 2026-12-31"
**FAIL:** "someday", "when I have time", "eventually", "ASAP"
**Severity:** medium

---

## 8. Progress Tracking Structure

### 8.1 Current State Populated for Active Goals
**RULE:** `current` should be populated for any goal with `status = 'active'` to reflect the last known state of progress. A null `current` on an active goal means progress is untracked.
**PASS:** `current = '3200 EUR saved'` for a savings goal. `current = 'completed A2, starting B1 course'` for a language goal.
**FAIL:** `status = 'active'`, `current = null` — no baseline or progress snapshot.
**Severity:** high

### 8.2 Current State Freshness
**RULE:** `current` should reflect a reasonably recent assessment. If `current` describes a state that is clearly outdated (e.g., references a date months in the past with no updates), it signals stale tracking.
**PASS:** `current` describes a state consistent with recent evidence or schedule outcomes.
**FAIL:** `current = 'started couch-to-5k week 1 (Jan 2025)'` still unchanged in Feb 2026.
**Severity:** medium

### 8.3 Current-Target Coherence
**RULE:** `current` and `target` should be expressed in compatible units/terms so that progress can be assessed by comparing them.
**PASS:** `metric = 'savings (EUR)'`, `target = '10000'`, `current = '3200'` — directly comparable.
**FAIL:** `target = '10000 EUR'`, `current = 'making progress'` — incomparable formats.
**Severity:** high

### 8.4 Achieved Goals Have Final State
**RULE:** When `status = 'achieved'`, `current` should reflect the final state that demonstrates goal completion.
**PASS:** `status = 'achieved'`, `current = '10500 EUR saved — target met 2026-09-15'`
**FAIL:** `status = 'achieved'`, `current = null` or `current` still showing an intermediate value.
**Severity:** medium

### 8.5 Dropped/Paused Goals Have Reason
**RULE:** When `status = 'dropped'` or `status = 'paused'`, the `current` field should explain why (or evidence should contain a justification entry).
**PASS:** `status = 'paused'`, `current = 'Paused due to injury — revisit after recovery (est. April 2026)'`
**FAIL:** `status = 'dropped'`, `current = null` — no explanation for why the goal was abandoned.
**Severity:** medium

---

## 9. Goal Set Coherence

### 9.1 No Contradictory Active Goals
**RULE:** Two active goals must not directly contradict each other.
**PASS:** Goals are mutually compatible or complementary.
**FAIL:** One active goal targets "minimize work hours to 30/week" while another targets "take on 3 additional freelance clients" — these are in tension without acknowledgment.
**Severity:** high

### 9.2 Life Dimension Coverage
**RULE:** The active goal set should cover multiple life dimensions from `smind_life_dimensions`. Heavy clustering in one dimension while others have zero goals suggests imbalance.
**PASS:** Active goals span at least 3 different life dimensions.
**FAIL:** All 8 active goals relate to career/work with zero goals for health, relationships, finance, etc.
**Severity:** low (informational)

### 9.3 No Stale Active Goals
**RULE:** Goals with `status = 'active'` should show signs of being actively worked on — either `current` has been updated, or schedule days reference the goal, or evidence has recent entries. An active goal with no activity signal is potentially stale.
**PASS:** Active goal with recent `current` update or referenced in `smind_schedule_days`.
**FAIL:** Active goal untouched for 90+ days with no schedule references.
**Severity:** medium

### 9.4 Reasonable Goal Count
**RULE:** The number of active goals should be manageable. Research suggests 3–7 concurrent goals is optimal. More than 10 active goals risks diffusion; fewer than 2 suggests under-utilization.
**PASS:** 3–10 active goals.
**FAIL:** 15+ active goals simultaneously (goal inflation). 0 active goals (system not being used).
**Severity:** low (informational)

---

## 10. Data Hygiene

### 10.1 No Placeholder/Test Rows
**RULE:** Every row must contain real, meaningful goal data. No placeholders, test entries, or skeleton rows.
**PASS:** Every row has substantive `outcome`, appropriate `metric`/`target`.
**FAIL:** `outcome = 'test goal'`, `key = 'goal_1'`, `metric = 'TBD'`.
**Severity:** high

### 10.2 No Duplicate Goals
**RULE:** Two rows must not express the same goal, even with different keys or slightly different wording.
**PASS:** One authoritative row per distinct goal.
**FAIL:** `learn_portuguese` and `portuguese_b2_fluency` both targeting Portuguese language proficiency with overlapping outcomes.
**Severity:** high

### 10.3 Achieved/Dropped Goals Retained Appropriately
**RULE:** Goals with `status = 'achieved'` or `status = 'dropped'` should be retained for historical record but must not be confused with active goals by downstream consumers (Scheduler). The `status` field alone handles this — but `current` should confirm the terminal state (see 8.4, 8.5).
**Severity:** low (informational)

---

## Appendix A: Evaluation Procedure for Evaluator Job

When evaluating, the Evaluator should:

1. **Scan all rows** in `smind_smart_goals`.
2. **Check each row** against all applicable rules from this benchmark.
3. **Group failures** by rule, not by row — one GitHub issue per rule violation pattern, listing all affected rows.
4. **Set issue priority** based on the severity of the violated rule.
5. **Include actionable fix descriptions** — what specifically should change (e.g., "add metric to goal X", "merge duplicate goals Y and Z", "add time-bound to outcome of goal W").
6. **Do NOT modify data** — only file issues. The Smart Goal Creator worker handles fixes.

## Appendix B: Severity Mapping to GitHub Issue Labels

| Severity | GitHub Label | Expected Response Time |
|----------|-------------|----------------------|
| critical | `priority: critical` | Must fix before next pipeline run |
| high | `priority: high` | Fix within 1-2 pipeline cycles |
| medium | `priority: medium` | Fix when convenient |
| low | `priority: low` | Nice to have / informational |

---

*This benchmark is self-improving. Each run of the Scientist job should review and enhance it.*
