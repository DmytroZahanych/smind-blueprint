# SMind Society Dashboard

Interactive visualization of the SMind Society — entities, artifacts, relationships, and daily schedule — rendered as a chord diagram with a live 24-hour time ring.

**Live:** Serve locally with `python3 -m http.server 8888` from this directory.

## What It Shows

- **Chord diagram** (inner ring): Entities and DB tables from `smind_society`, with relationship chords showing ownership (writes) and read dependencies
- **24-hour time ring** (outer ring): Real-time clock (Europe/Lisbon), quiet/active zones, cron job markers, heartbeat ticks
- **Sweeping arc connections**: Entity-to-cron-job and Face-to-heartbeat connections that route around the label zone (never through the center)

## Architecture

Single `index.html` file. No build step, no dependencies, no frameworks. Pure HTML5 Canvas + vanilla JS.

### Rendering Pipeline

Everything is drawn on a 1800×1800 canvas inside a pan/zoom viewport:

1. **Background** (`canvas#bg`): Static grid, scan lines, radial gradient — drawn once
2. **Main canvas** (`canvas#main`): Redrawn every frame via `requestAnimationFrame`

Render order in `render(hoverSeg, hoverCron)`:
1. Guide circles (faint decorative rings)
2. 24h time ring: quiet/active zone fills → elapsed time fill → ring borders → hour ticks → "now" sweep line + dot
3. Minute progress ring (orbits on the "now" dot)
4. Cron job markers + sweeping arc connections to entities
5. Heartbeat ticks + sweeping arc connections to Face
6. Inner relationship chords (entity↔table bezier curves)
7. Segment arcs (entity/DB table ring)
8. Labels (tangent to arc, split on `_`)
9. Center text

### Key Radii (from center outward)

```
minuteRingR   = 120px    (decorative, unused — minute ring orbits on time ring now)
innerR        = 300px    (inner edge of entity/DB arcs)
outerR        = 328px    (outer edge of entity/DB arcs)
childOuterR   = 344px    (intermediate artifact bars — benchmark.md, score.md, work.md)
labelStart    = 352px    (start of label zone)
hbArcR        = ~420px   (heartbeat sweeping arcs lane)
arcR          = ~445px   (cron job sweeping arcs lane)
timeRingInner = 504px    (inner edge of 24h time ring)
timeRingOuter = 528px    (outer edge of 24h time ring)
timeLabelR    = 546px    (hour labels)
```

### Data Model

All data is hardcoded in the JS (no API calls):

**Segments** (ring around the chord diagram):
- Entities from `smind_society` table: UDM, SGC, Scheduler, Face Assistant, Face, Sprint Planner, Snapshot
- DB tables as separate segments: profile_as_items, scheduling_constraints, history, smart_goals, schedule_days, outcomes, questions, sprints, snapshots

**Relationships** `[sourceId, targetId, type, strength]`:
- `type`: `'owns'` (entity writes to table) or `'reads'` (entity reads from table)
- `strength`: 1-3, affects line thickness

**Cron jobs** (markers on time ring):
- Read from OpenClaw cron store (`/root/.openclaw/cron/jobs.json`)
- Currently: `withings-daily-sync` (11:05) → UDM, `database_snapshot` (23:30) → Snapshot

**Heartbeats** (tick marks on time ring):
- Generated: every hour during active hours (08:00-22:00)
- All connected to Face entity
- Config: `heartbeat.every: "1h"` in OpenClaw config

### Interaction

**Pan & Zoom:**
- Scroll wheel to zoom (0.2x–5x), pivots around cursor
- Click+drag to pan
- Buttons: +/−/⊙ (fit to view)

**Hover tooltips (3 hit zones):**
1. **Entity/DB segments** (innerR to childOuterR): Shows description, owned artifacts, relationships, cron jobs
2. **Time ring hours** (timeRingInner ± 15px): Shows time slot, zone, status, scheduled jobs
3. **Cron job dots / heartbeat ticks** (timeRingInner ± 20px): Shows job details, entity, countdown

**Hover highlighting:**
- Hovering an entity dims everything else, brightens its chords + cron arcs
- Hovering a cron dot highlights parent entity + its chords (bidirectional)
- Hovering a heartbeat tick highlights Face entity + its chords

### Styling

Sci-fi HUD aesthetic inspired by FUI (Fantasy User Interface) design:
- Background: `#060a12` → `#0c1220` radial gradient
- Entity color: `#d4845a` (warm copper/orange)
- DB table color: `#4a9aca` (cool blue)
- Intermediate artifacts: `#3a8a6a` (green)
- Heartbeats: inherit Face color (`#c47a50`)
- Font: `Share Tech Mono` (monospace, techy) + `Rajdhani` (headers)
- Scan lines, grid, glow effects for depth

### Labels

- Rendered tangent to arc (horizontal relative to segment position)
- Auto-flipped so text is never upside down
- Long names split on `_` into multi-line stacks

## Updating

### Adding a new cron job
1. Add entry to `cronJobs` array: `{name, entityId, hour, minute, emoji}`
2. `entityId` must match a segment `id`
3. Sweeping arc + time ring marker appear automatically

### Adding a new entity
1. Add to `segments` array with `type:'entity'`
2. Add relationships to `relationships` array
3. If it has cron jobs, add those too

### Adding a new DB table
1. Add to `segments` array with `type:'db'`
2. Add ownership/read relationships

### Changing heartbeat interval
Update the `heartbeats` generation loop (currently `for hh=8; hh<23`).

## Infra Map Screen

Third screen showing infrastructure topology — devices, servers, cloud services, VPNs, and data flows.

### What It Shows

- **Zone backgrounds**: Faint bordered regions grouping devices, cloud services, and network overlay
- **Node cards**: Rounded rects with emoji + name, colored by type (device/server/service/vpn)
- **Edge lines**: Data flows with animated particles showing direction; VPN edges are dashed purple
- **Hover tooltips**: Node details + all connections with direction indicators

### Data Model

All data lives in `viewmodel.json` under `infraMap`:
- `zones` — grouping regions with color
- `nodes` — infrastructure components with precomputed x,y positions on a 2000×2000 canvas
- `edges` — connections with type (data/api/vpn/sensor) and directionality

### Updating

- **Add a service**: Add node to `infraMap.nodes`, add edges to `infraMap.edges`
- **Add a device**: Same pattern, set `zone: "devices"`
- **Change connections**: Update `infraMap.edges`, set `bidirectional` flag as needed

## Life Dimensions Screen

Fourth screen showing life dimension coverage as cards — extracted from the Smart Goals coverage benchmark.

### What It Shows

- **Aggregate score** at top (89/100 currently)
- **4 tier rows** (Immediate, Medium-Term, Long-Term, Existential & Meta), each with tier header showing name + score
- **Dimension cards**: uniformly-sized rounded rectangles with colored borders (🟢 green = covered, 🟡 amber = partial, 🔴 red = uncovered)
- **Each card**: dimension number, name, goal count, sub-dimension progress bar
- **Discovery queue** at bottom: dimmer cards with dashed borders for unconfirmed dimensions

### Hover Behavior

- **Card hover**: radar pulse, tooltip with full details (description, sub-dimensions with gap indicators, mapped goals, cross-dimensional links)
- **Cross-dimensional lines**: on hover, dashed FUI lines connect the hovered card to related cards, non-related cards dim

### Data Model

All data lives in `viewmodel.json` under `lifeDimensions`. Source: `society/smart_goals/coverage_benchmark.md` + `score_coverage.md`.

### Updating

- **After goal changes**: Re-run coverage benchmark/score, then regenerate the `lifeDimensions` section of viewmodel.json
- **Add dimension**: Update benchmark, regenerate viewmodel

## hOS Dimensions Screen

Fifth screen showing the contrast between hOS's naive 7-category life model and SMind's actual 25-dimension model as concentric rings.

### What It Shows

- **Outer ring:** 7 hOS categories (Health, Finances, Career, Relationships, Spirituality, Enjoyment, Impact) as uniform-width arcs with FUI colors
- **Inner ring:** SMind dimensions subdivided within each hOS category's angular space, colored by coverage status (green=covered, amber=partial, red=uncovered)
- **Sub-dimension ring:** Innermost thin arcs showing individual sub-dimensions within each SMind dimension
- **"BEYOND hOS" section:** Unmapped SMind dimensions (1.5, 2.4, 4.4, 4.6, 4.8) with dashed outer ring gap, showing what hOS misses
- **Center:** 🧠 SMIND text

### Visual Design

Approach B — Contrast Rings. Each hOS category gets angular space proportional to the number of sub-dimensions in its mapped SMind dimensions. Health dominates (11 dimensions, 40+ sub-dims) while Finances is sparse (1 dimension). This visually demonstrates the naivety of equal-weight category systems.

### Hover Behavior

- **Inner ring (SMind dimension):** Tooltip shows dimension name, status, sub-dimension coverage, hOS mapping
- **Outer ring (hOS category):** Highlights all inner segments within that category, shows dimension list
- **Sub-dimension ring:** Same as hovering the parent dimension

### Data Model

`hosDimensions` in viewmodel.json contains the category-to-dimension mapping. Dimension details are cross-referenced from `lifeDimensions` at render time.

### Updating

- **New hOS mapping:** Update `hosDimensions.categories` in viewmodel.json
- **New SMind dimension:** Add to appropriate category or unmapped list, ensure it exists in `lifeDimensions`

## Version History

- **v0.1.0** — Initial chord diagram with live time ring
- **v0.2.0** — Interactive time ring hour tooltips, fixed labels
- **v0.3.0** — Sweeping arc connections with bidirectional hover
- **v0.4.0** — Heartbeat ticks with Face connections
