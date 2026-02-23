# GENERATE.md — How to regenerate viewmodel.json

Rebuild `viewmodel.json` from live Supabase data + workspace files. Run after society runs, schema changes, goal updates, or new entities.

Write `viewmodel.json` in this directory. The dashboard reads it on page load (`fetch('viewmodel.json')`). If a data source is empty or missing, use sensible defaults — never fail the entire generation because one section has no data.

## viewmodel.json structure

```json
{
  "version": "v0.X.0",
  "generatedAt": "ISO-8601 timestamp",
  "config": {},
  "segments": [],
  "relationships": [],
  "cronJobs": [],
  "userModel": {},
  "lifeDimensions": {},
  "hosDimensions": {}
}
```

---

## 1. `config`

Hardcoded from USER.md:

```json
{
  "quietStart": 22,
  "quietEnd": 8,
  "timezone": "Europe/Lisbon",
  "heartbeatEntityId": "face",
  "heartbeatEmoji": "💓"
}
```

**Used by:** Time ring quiet/active zone rendering, heartbeat generation loop.

## 2. `segments`

Three types. All go into the same flat array.

### Entities (type: "entity")

**Source:** `SELECT * FROM smind_society WHERE enabled = true`

```json
{
  "id": "<slug>", "name": "<name>", "type": "entity",
  "emoji": "<emoji>", "children": [...], "desc": "<description>"
}
```

Standard 7 entities:

| ID | Name | Emoji | Children |
|---|---|---|---|
| udm | User Data Maintainer | 🔧 | `["score.md", "work.md"]` |
| sgc | Smart Goal Creator | 🎯 | `["score.md", "work.md"]` |
| sch | Scheduler | 📅 | `["score.md", "work.md"]` |
| face_ast | Face Data Gaps Assistant | 🎭 | `["score.md", "work.md"]` |
| face | Face | 💬 | `[]` |
| snap | Snapshot | 📸 | `[]` |
| scientist | Scientist | 🔬 | `["user_data_maintainer_benchmark.md", "smart_goals_structural_benchmark.md", "smart_goals_coverage_benchmark.md", "scheduling_benchmark.md", "face_data_gaps_assistant_benchmark.md"]` |

Face gets `"colorOverride": "#c47a50"`.

**Dashboard:** These populate the **outer ring** on the Society screen.

### DB Tables (type: "db")

**Source:** `SCHEMA.md` or `information_schema.tables WHERE table_schema = 'public'`

```json
{
  "id": "<slug>", "name": "<full_table_name>", "type": "db",
  "emoji": "🗄️", "children": [], "desc": "<description>"
}
```

Required table segments:

| ID | Table | Mini-ring |
|---|---|---|
| profile | user_model_profile_as_items | User Data (bottom-right) |
| scheduling_constraints | user_model_scheduling_constraints_and_preferences | User Data (bottom-right) |
| history | user_data_history | User Data (bottom-right) |
| goals | smind_smart_goals | Society Tables (bottom-left) |
| schedule_days | smind_schedule_days | Society Tables (bottom-left) |
| schedule_today | smind_schedule_today | (not on mini-ring but used) |
| schedule_outcomes | smind_schedule_outcomes | Society Tables (bottom-left) |
| questions | smind_data_gap_questions | Society Tables (bottom-left) |
| society | smind_society | (not on mini-ring) |
| core_jobs | smind_society_core_jobs | (not on mini-ring) |

**Dashboard:** `profile`, `scheduling_constraints`, `history` → inner mini-ring "USER DATA". `goals`, `schedule_days`, `schedule_outcomes`, `questions` → inner mini-ring "SOCIETY TABLES". A third mini-ring "INTEGRATIONS" uses hardcoded source segments in index.html (`withings_src`, `telegram_src`, `google_src`, `github_src`).

#### Goals segment: detail data for side panel

**Source:** `SELECT key, outcome, metric, target, current, status FROM smind_smart_goals ORDER BY key`

For the `goals` segment, populate `children` with full goal objects (not filenames):

```json
{
  "id": "goals",
  "name": "smind_smart_goals",
  "type": "db",
  "children": [
    {
      "key": "nutrition-intermittent-fasting-6h",
      "outcome": "Maintain consistent 6-hour eating window...",
      "metric": "Days per week within eating window",
      "target": "≥5 days/week",
      "current": "No consistent fasting routine...",
      "status": "active"
    }
  ]
}
```

**Dashboard:** Clicking the goals segment on Society screen opens a detail panel listing these goals. Also used by hOS dimension ring: goals are cross-referenced by key from `lifeDimensions.tiers[].dimensions[].goals[]` to show in hover tooltips.

### Integrations (type: "integration")

**Source:** TOOLS.md — only include what's actually configured.

```json
{"id": "github", "name": "GitHub", "type": "integration", "emoji": "🐙", "children": [], "desc": "..."},
{"id": "withings", "name": "Withings", "type": "integration", "emoji": "⚖️", "children": [], "desc": "..."},
{"id": "telegram", "name": "Telegram", "type": "integration", "emoji": "📱", "children": [], "desc": "..."}
```

**Dashboard:** These segments exist in viewmodel but the Society screen uses hardcoded source segments for the inner INTEGRATIONS mini-ring instead. Include them for documentation/consistency.

## 3. `relationships`

**Source:** `smind_society_core_jobs` instructions + AGENTS.md protocols.

Tuple: `[sourceId, targetId, "owns"|"reads"|"bidi", weight]`

**⚠️ Important:** The Society screen does **NOT** read relationships from viewmodel. Cross-ring connections are hardcoded in `index.html` as `crossRingRelationships`. Generate relationships anyway for documentation. If entity responsibilities change, update **both** viewmodel relationships AND `crossRingRelationships` in `index.html`.

## 4. `cronJobs`

**Source:** OpenClaw cron list (`cron` tool, action: list).

```json
{
  "name": "<job name>",
  "entityId": "<entity slug>",
  "hour": <hour in Europe/Lisbon>,
  "minute": <minute>,
  "emoji": "<emoji>"
}
```

Exclude heartbeat jobs (heartbeats are generated in code from `config.quietEnd` to `config.quietStart`). Map job names to entity IDs based on prefix (e.g., `smart_goals_*` → `sgc`, `scheduling_*` → `sch`, `user_data_*` → `udm`, `face_data_gaps_*` → `face_ast`, `snapshot_*` → `snap`, `withings*` → `udm`).

**Dashboard:** Cron markers on the time ring with sweeping arc connections to their parent entity.

## 5. `userModel`

Powers the User Model screen (separate canvas, accessed via side panel navigation).

**Source:** `SELECT key, title, tags, summary, evidence FROM user_model_profile_as_items`

### Node layout

Nodes need pre-computed `x, y` positions on a 4000×4000 canvas. Layout approach:
- Group by primary tag (first tag in array)
- Cluster nodes with shared tags together
- Use force-directed or grid layout per cluster
- Spread clusters across the canvas with spacing

```json
{
  "nodes": [
    {
      "id": "<key>",
      "label": "<title>",
      "tags": ["health", "supplements"],
      "evidenceCount": 3,
      "summary": "<summary text>",
      "x": 2891.8,
      "y": 1306.4
    }
  ],
  "edges": [
    {"source": "<key1>", "target": "<key2>", "sharedTags": ["health", "habits"], "weight": 2}
  ],
  "tagColors": {
    "health": "#4acaaa",
    "habits": "#d4845a",
    "immigration": "#6a9aca"
  },
  "config": {
    "minEdgeWeight": 2,
    "maxEdges": 500,
    "defaultNodeColor": "#5a6a7a",
    "defaultEdgeColor": "#2a3a4a",
    "nodeBaseSize": 3
  }
}
```

**Edges:** Generated from pairs of nodes sharing ≥`minEdgeWeight` tags. `weight` = number of shared tags. Cap at `maxEdges` (drop lowest weight first).

**tagColors:** Top ~15 most frequent tags mapped to a FUI color palette. Other tags use `defaultNodeColor`.

**Dashboard:** Renders as a force-graph-like visualization with hover tooltips, click-to-chain selection, and cluster labels.

## 6. `lifeDimensions`

Powers the hOS dimension rings on the Society screen (3 concentric rings outside the time ring) and the Rehoboam halo animation.

**Source:** `society/smart_goals/coverage_benchmark.md` + `society/smart_goals/score_coverage.md`

```json
{
  "overallScore": 89,
  "maxScore": 100,
  "tiers": [
    {
      "id": "tier1",
      "name": "Immediate",
      "weight": 40,
      "maxPoints": 40,
      "scored": 35,
      "dimensions": [
        {
          "id": "1.1",
          "name": "Nutrition & Diet",
          "status": "partial",
          "goalCount": 2,
          "goals": ["nutrition-intermittent-fasting-6h", "nutrition-eliminate-daily-sweets"],
          "desc": "...",
          "subDimensions": [
            {"name": "Meal timing/fasting", "covered": true},
            {"name": "Sugar reduction", "covered": true},
            {"name": "Macro balance", "covered": false}
          ]
        }
      ]
    }
  ],
  "crossDimensional": [{"from": "1.1", "to": "2.3", "label": "..."}],
  "discoveryQueue": [{"name": "...", "reason": "..."}]
}
```

### ⚠️ CRITICAL: `status` field derivation

**Derive `status` from actual sub-dimension coverage, NOT from goal count or goal mapping:**

```
if all subDimensions.covered == true  → "covered"
if some subDimensions.covered == true → "partial"  
if no subDimensions.covered == true   → "uncovered"
if no subDimensions exist             → "uncovered"
```

**Do NOT** set status based on whether goals exist. A dimension with 2 goals but 2/8 sub-dimensions covered is `"partial"`, not `"covered"`.

This field drives:
- **Middle ring arc colors:** green (covered), amber (partial), red (uncovered) via `statusColor` map
- **Category ring hover tooltips:** 🟢/🟡/🔴 icons
- **Rehoboam halo:** The halo reads `subDimensions[].covered` directly to compute gap ratio, but `status` affects the dimension arc coloring

### `goals` array

Array of goal **keys** (strings matching `smind_smart_goals.key`). At render time, the dashboard cross-references these against the `goals` segment's children to build hover tooltips with full goal details.

### `subDimensions` array

Each sub-dimension needs:
- `name`: descriptive name
- `covered`: boolean — true if at least one goal addresses this sub-dimension

**Dashboard uses:**
- Sub-dimension ring (innermost thin arcs): colored green/red per `covered`
- Hover tooltips: show ✅/❌ per sub-dimension
- Halo thorn sizing: `1 - (coveredCount / totalCount)` = gap ratio per dimension

## 7. `hosDimensions`

Maps hOS's 7 life categories to SMind dimension IDs. Relatively stable — only update when categories or dimension assignments change.

**Source:** Copy from previous viewmodel.json. Update if new SMind dimensions are added or category mapping changes.

```json
{
  "categories": [
    {"id": "health", "name": "Health", "color": "#4acaaa", "dimensions": ["1.1", "1.2", "1.3", "1.4", "2.1", "2.2", "2.3", "2.5", "2.6", "3.1", "3.2"]},
    {"id": "finances", "name": "Finances", "color": "#d4a45a", "dimensions": ["3.4"]},
    {"id": "career", "name": "Career", "color": "#4a8aca", "dimensions": ["3.3"]},
    {"id": "relationships", "name": "Relationships", "color": "#ca6a8a", "dimensions": ["3.5"]},
    {"id": "spirituality", "name": "Spirituality", "color": "#8a6aca", "dimensions": ["4.1", "4.5"]},
    {"id": "enjoyment", "name": "Enjoyment", "color": "#6aca8a", "dimensions": ["4.3"]},
    {"id": "impact", "name": "Impact", "color": "#ca8a4a", "dimensions": ["4.6"]}
  ],
  "unmapped": {
    "label": "Individual",
    "color": "#6a5aca",
    "dimensions": ["1.5", "2.4", "4.2", "4.4", "4.7", "4.8", "4.9"]
  }
}
```

**Dashboard:** Outer hOS category ring gets angular space proportional to number of sub-dimensions in mapped SMind dimensions. Dimension details are cross-referenced from `lifeDimensions` at render time.

**When new dimensions are added:** Assign to appropriate category or add to `unmapped.dimensions`.

## 8. `version` and `generatedAt`

- Check existing `viewmodel.json` version, increment patch: `v0.55.0` → `v0.56.0`
- Set `generatedAt` to current ISO-8601 timestamp with timezone

---

## What powers what (quick reference)

| Dashboard Feature | viewmodel section | Key fields |
|---|---|---|
| Outer ring (entities) | `segments` type=entity | id, name, emoji, children |
| Inner mini-rings (tables) | `segments` type=db | id, name (code assigns to rings by id) |
| Cross-ring connections | **hardcoded in index.html** | (viewmodel relationships are docs only) |
| Time ring markers | `cronJobs` | hour, minute, entityId |
| Heartbeat ticks | **generated in code** from config | quietStart, quietEnd, heartbeatEntityId |
| hOS outer ring | `hosDimensions.categories` | dimensions[], color |
| hOS middle ring | `lifeDimensions.tiers[].dimensions[]` | status, startAngle/endAngle (computed at render) |
| hOS sub-dim ring | `lifeDimensions...subDimensions[]` | covered (boolean) |
| Rehoboam halo thorns | `lifeDimensions...subDimensions[]` | covered — gap ratio drives spike height |
| Goal detail panel | `segments` goals.children[] | key, outcome, metric, target, current, status |
| Goal hover on dimensions | `lifeDimensions...goals[]` cross-ref'd to goals segment | goal keys |
| User Model graph | `userModel` | nodes (with x,y), edges, tagColors |
| Constitution mode names | **hardcoded in index.html** | (cosmetic vocabulary swap) |

## Generation Steps

1. Read USER.md, TOOLS.md, SCHEMA.md for context
2. Query Supabase:
   - `smind_society` → entity segments
   - `smind_smart_goals` → goals segment children
   - `user_model_profile_as_items` → userModel nodes
3. Read `society/smart_goals/coverage_benchmark.md` + `score_coverage.md` → lifeDimensions
4. List cron jobs → cronJobs
5. Copy `hosDimensions` from previous viewmodel (stable mapping)
6. **Derive dimension status from sub-dimension coverage** (see critical rule above)
7. Compute userModel edges from shared tags, assign x/y positions
8. Assemble all sections, increment version, write `viewmodel.json`

## Common Pitfalls

- **Status field:** Must be derived from sub-dimension coverage, not goal count. See critical rule above.
- **Goal keys:** Must match between `segments[goals].children[].key` and `lifeDimensions...goals[]` for cross-referencing to work.
- **Node positions:** userModel nodes need pre-computed x,y on a 4000×4000 canvas. If adding new nodes, recompute layout.
- **Relationships:** Updating viewmodel relationships alone does NOT change the Society screen. Must also update `crossRingRelationships` in index.html.
- **infraMap:** Section exists in schema but the Infra Map screen has been removed from the dashboard. Can be omitted.
