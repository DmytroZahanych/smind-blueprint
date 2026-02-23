# Life Dimensions Benchmark v1.0.0

Structural quality criteria for rows in `smind_life_dimensions`. This benchmark defines **how** dimensions should be structured, not **which** dimensions should exist.

## Schema Reference

```
smind_life_dimensions:
  id   text primary key
  name text not null
  description text
```

## Criteria

### C1 — ID Format
- Lowercase, snake_case, ASCII only.
- Max 40 characters.
- Must be semantically meaningful (not opaque codes).
- Sub-dimensions use dot notation: `parent.child` (max 2 levels).

### C2 — Name Clarity
- Human-readable, concise (2–6 words).
- No jargon or abbreviations without context.
- Must be understandable without reading the description.

### C3 — Description Completeness
- Description must be non-null and ≥ 30 characters.
- Must define the **scope** — what falls inside this dimension.
- Must define at least one **boundary** — what is explicitly excluded or belongs to a neighboring dimension.
- Must not repeat the name verbatim as the sole content.

### C4 — Granularity
- A top-level dimension should be **broad enough** to contain ≥ 2 plausible sub-concerns, but **narrow enough** that a single sentence can describe its scope.
- Sub-dimensions (if used) should be **actionable** — a goal or scheduling block could reasonably target one.
- Avoid both extremes: dimensions so broad they're meaningless ("life stuff") and so narrow they're single activities ("Tuesday yoga").

### C5 — Mutual Exclusivity and Overlap Policy
- **Preferred:** dimensions are mutually exclusive at the same hierarchy level.
- **Tolerated:** minor overlap when a clean split would be artificial, but the overlap must be acknowledged in the description of both dimensions (e.g., "overlaps with X regarding Y").
- **Violation:** two dimensions at the same level where one is a strict subset of the other.

### C6 — Collectively Exhaustive (Aspirational)
- The full set of top-level dimensions should plausibly cover all areas of a person's life that could generate goals or scheduling needs.
- This is evaluated holistically across the set, not per-row.
- A gap is a structural issue to flag, not necessarily a per-dimension violation.

### C7 — Independence from Specific Goals or Activities
- Dimensions describe **life areas**, not goals, habits, or tasks.
- A dimension should outlive any single goal within it.
- Bad: "learn Spanish" (that's a goal). Good: a dimension that *could contain* "learn Spanish" among other things.

### C8 — Stability
- Dimensions should be relatively stable over months/years. Frequent churn (weekly renames, splits, merges) indicates poor granularity choices.
- This is assessed longitudinally, not on a single snapshot.

## Scoring

Each row is scored per criterion: **pass** (1), **partial** (0.5), **fail** (0).

| Criterion | Weight |
|-----------|--------|
| C1 ID Format | 1 |
| C2 Name Clarity | 1 |
| C3 Description Completeness | 2 |
| C4 Granularity | 2 |
| C5 Mutual Exclusivity | 1 |
| C6 Collectively Exhaustive | 1 |
| C7 Independence | 1 |
| C8 Stability | 1 |

**Row score** = weighted sum / max possible (per-row criteria: C1–C5, C7).  
**Set score** = row scores average + set-level criteria (C6, C8) scored once for the whole table.

### Thresholds
- **Green:** row score ≥ 0.8, set score ≥ 0.8
- **Yellow:** row score ≥ 0.5, set score ≥ 0.5
- **Red:** below yellow

## Evaluator Guidance

- Score C1–C4, C7 per row.
- Score C5 per pair of same-level dimensions (flag pairs, not individual rows).
- Score C6 and C8 once for the full set.
- When creating GitHub issues, reference the specific criterion code (e.g., "C3 violation: description is null").
