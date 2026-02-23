# Enjoyment Dimensions Benchmark v1.0.0

Defines what life dimensions should exist in `smind_life_dimensions` to comprehensively cover **Enjoyment** — leisure, hobbies, fun, creativity, and experiences that bring joy.

This benchmark is consumed by the Evaluator, which compares it against actual dimension data. It defines **WHAT** areas must be covered, not exact dimension IDs.

---

## Scope Definition

**Enjoyment** encompasses all activities, pursuits, and experiences whose primary purpose is pleasure, fulfillment, fun, creative expression, or recreation — as distinct from obligations (work, chores) or self-improvement (fitness goals, skill-building for career). Note: many activities blend enjoyment with other life areas; a dimension belongs here if enjoyment is a primary motivator.

---

## Required Coverage Areas

The Evaluator should verify that `smind_life_dimensions` contains dimensions (or sub-dimensions) that collectively cover **all** of the following areas. Each area may be covered by one dimension or split across multiple — what matters is that no area is left unaddressed.

### A1 — Hobbies & Personal Projects

Activities pursued for intrinsic interest, not professional obligation.

**Must cover:**
- Ongoing hobbies (e.g., woodworking, gardening, collecting, gaming, cooking for pleasure)
- Personal projects with no commercial intent (building something, tinkering, restoration)
- Hobby acquisition and exploration (trying new hobbies, rotating interests)

**Boundary:** If the hobby is pursued primarily for income or career advancement, it belongs under Career/Work, not Enjoyment. If it's primarily for health (e.g., recreational running where the main goal is fitness), it belongs under Health. Dual-purpose activities should be acknowledged.

### A2 — Creative Expression & Arts

Making things for the joy of creation.

**Must cover:**
- Visual arts (drawing, painting, photography, digital art)
- Performing arts (music-making, singing, dance, theater — as participant)
- Writing for pleasure (fiction, poetry, journaling-as-creative-practice)
- Crafts and making (knitting, pottery, 3D printing for fun)
- Digital creation (video editing, game modding, creative coding)

**Boundary:** Professional creative work belongs under Career. Consumption of art (watching, reading, listening) belongs under A3 (Entertainment & Media). The distinction is active creation vs. passive consumption.

### A3 — Entertainment & Media Consumption

Passive or semi-passive engagement with content created by others.

**Must cover:**
- Film, TV, streaming content
- Music listening
- Reading for pleasure (fiction, non-fiction read for enjoyment, comics, manga)
- Podcasts and audiobooks (non-educational intent)
- Video games (as consumer/player)
- Live entertainment (concerts, theater, comedy shows, sports spectating)
- Social media browsing for entertainment (distinct from professional networking)

**Boundary:** Educational content consumed for learning belongs under Personal Growth/Education. News consumption may overlap with Civic engagement. Gaming as a competitive/social activity overlaps with A6.

### A4 — Travel & Exploration

Experiences of new places, cultures, and environments for pleasure.

**Must cover:**
- Vacation travel (domestic and international)
- Day trips and local exploration
- Adventure travel (hiking trips, road trips, backpacking)
- Cultural tourism (museums, historical sites, food tourism)
- Nature exploration (national parks, scenic drives, wildlife watching)
- Urban exploration and wandering

**Boundary:** Business travel belongs under Career. Relocation logistics belong under Life Admin. Outdoor activities primarily for fitness belong under Health.

### A5 — Play & Spontaneous Fun

Unstructured, often social, lighthearted activity.

**Must cover:**
- Spontaneous outings and adventures
- Games and play (board games, party games, playground, sports-for-fun)
- Humor and comedy (joke-telling, meme culture, comedy consumption)
- Playful experimentation (trying weird food, random challenges)
- Festive and celebratory activities (parties, festivals, themed events)

**Boundary:** Organized competitive sports belong under Health/Fitness or a Sports dimension. Structured social gatherings primarily for relationship maintenance belong under Relationships.

### A6 — Social Enjoyment

Fun derived specifically from being with others.

**Must cover:**
- Hanging out with friends (unstructured social time)
- Group activities for fun (group dinners, game nights, karaoke)
- Community events and meetups attended for enjoyment
- Online social fun (multiplayer gaming, Discord hangouts, group chats)
- Shared experiences (attending events together, group travel)

**Boundary:** Deep relationship maintenance (supporting a friend through crisis, family obligations) belongs under Relationships. Professional networking belongs under Career. The key marker is that the primary intent is mutual enjoyment.

### A7 — Rest, Relaxation & Restoration

Deliberate unwinding and pleasure-oriented downtime.

**Must cover:**
- Leisure relaxation (lounging, napping for pleasure, hammock time)
- Pampering and self-care-as-enjoyment (spa, baths, massage — when the primary intent is pleasure, not health)
- Mindless decompression (zoning out, scrolling without purpose)
- Nature-based relaxation (sitting in a park, watching sunsets, beach time)
- Comfort rituals (favorite drink, cozy setup, comfort food)

**Boundary:** Sleep hygiene and recovery sleep belong under Health. Meditation and mindfulness practiced for mental health belong under Health/Wellbeing. The distinction: rest here is chosen for pleasure, not prescribed for wellness.

### A8 — Culinary Enjoyment

Food and drink pursued for pleasure beyond nutrition.

**Must cover:**
- Cooking and baking as recreation (distinct from meal prep as chore)
- Dining out and restaurant exploration
- Food and drink appreciation (wine, coffee, craft beer, tea culture)
- Food-related experiences (food festivals, cooking classes, tastings)
- Experimenting with recipes and cuisines

**Boundary:** Meal planning for nutrition belongs under Health. Grocery shopping and meal prep as household obligation belongs under Life Admin.

### A9 — Novelty & New Experiences

The pursuit of the unfamiliar for its own sake.

**Must cover:**
- Trying new activities (first-time experiences, bucket list items)
- Learning-for-fun (picking up a skill purely for enjoyment, not career)
- Curiosity-driven exploration (going down rabbit holes, investigating random interests)
- Sensory novelty (new music genres, unfamiliar cuisines, unusual experiences)
- Serendipity and surprise (leaving room for unplanned discoveries)

**Boundary:** Structured education and skill development for career belong under Education/Career. The marker: the primary driver is curiosity and pleasure, not obligation or advancement.

### A10 — Nature & Outdoor Recreation

Enjoyment derived from the natural world.

**Must cover:**
- Outdoor leisure (picnics, beach days, park visits)
- Wildlife and nature appreciation (birdwatching, stargazing, nature photography)
- Gardening for pleasure (distinct from subsistence or obligation)
- Outdoor sports-for-fun (casual hiking, kayaking, skiing — when fun is the primary goal)
- Seasonal outdoor enjoyment (autumn leaves, snow play, spring flowers)

**Boundary:** Serious athletic training outdoors belongs under Health/Fitness. Wilderness survival or endurance challenges may straddle both.

---

## Completeness Criteria

The Evaluator should check:

1. **Area coverage:** Every area A1–A10 has at least one corresponding dimension (or clear sub-dimension) in `smind_life_dimensions`. A single dimension may cover multiple areas if its description explicitly addresses them.

2. **No orphan enjoyment activities:** Common enjoyment activities (gaming, reading for fun, travel, cooking for pleasure, socializing for fun) should each have a clear home in at least one dimension. If an evaluator can name a common enjoyment activity with no dimensional home, that's a gap.

3. **Active vs. passive balance:** The dimension set should not be skewed entirely toward passive consumption (A3) or entirely toward active creation (A2). Both modes of enjoyment must be represented.

4. **Social vs. solo balance:** Both social enjoyment (A6) and solo enjoyment activities should have dimensional homes. A system that only tracks group fun or only tracks solitary hobbies is incomplete.

5. **Structured vs. spontaneous balance:** Both planned enjoyment (hobbies, travel) and spontaneous/unstructured fun (A5, A7) should be represented.

---

## Anti-Patterns

The Evaluator should flag these as problems:

- **Enjoyment collapsed into one dimension:** A single "hobbies" or "leisure" dimension covering all of A1–A10 is too coarse for meaningful goal-setting or scheduling.
- **Enjoyment absent entirely:** No dimensions with enjoyment-related scope.
- **Enjoyment subsumed under Health:** Rest and relaxation treated only as health recovery, never as pleasure.
- **Missing creative dimension:** No dimension covering active creative expression.
- **Missing social-fun dimension:** Social enjoyment only covered under Relationships (which implies obligation/maintenance rather than fun).
- **No travel/exploration dimension:** Travel is a major life enjoyment area and should not be invisible.

---

## Versioning

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-20 | Initial benchmark with 10 coverage areas, completeness criteria, and anti-patterns |
