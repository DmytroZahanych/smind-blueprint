# Impact Dimensions Benchmark v1.0.0

Defines what life dimensions should exist in `smind_life_dimensions` to comprehensively cover **Impact** — contribution to others, community, legacy, and making a difference beyond oneself.

This benchmark defines WHICH areas must be covered, not how dimensions are structured (see `life_dimensions_benchmark.md` for structural criteria).

---

## How to Use This Benchmark

An Evaluator should check that `smind_life_dimensions` contains at least one dimension covering each Required Area below. A dimension "covers" an area if its `name` + `description` clearly address the area's scope. Partial or tangential overlap does not count.

---

## Required Areas

### RA1 — Direct Service & Volunteering
**Scope:** Unpaid, hands-on contribution of time/effort to help others or serve a cause. Includes formal volunteering (organizations, shelters, disaster relief) and informal helping (neighbors, strangers, community mutual aid).
**Why required:** The most immediate, tangible form of impact. Omitting it would miss the baseline of personal contribution.
**Boundary:** Excludes paid professional work (even if socially beneficial) — that belongs in career/work dimensions.

### RA2 — Mentoring & Teaching
**Scope:** One-on-one or small-group knowledge transfer aimed at developing other people. Includes formal mentorship programs, tutoring, coaching, advising junior colleagues, parenting-as-teaching, and informal guidance relationships.
**Why required:** Multiplicative impact — helping someone grow creates compounding downstream effects. Distinct from volunteering (skill-transfer vs. labor) and from knowledge sharing (personal relationship vs. broadcast).
**Boundary:** Excludes mass content creation (that's RA3). Excludes professional consulting-for-pay unless pro bono.

### RA3 — Knowledge Sharing & Thought Leadership
**Scope:** Broadcasting knowledge, ideas, or expertise to a wider audience. Includes writing (blogs, books, articles), speaking (talks, podcasts, conferences), open-source contributions, creating educational content, and publishing research.
**Why required:** Scales impact beyond direct relationships. Many people's largest contribution comes through ideas, not direct service.
**Boundary:** Excludes private mentoring (RA2). Excludes creative expression primarily for self-fulfillment (that's an arts/creativity dimension).

### RA4 — Community Building & Civic Participation
**Scope:** Strengthening communities and participating in collective governance. Includes organizing community groups, neighborhood involvement, local politics, voting, activism, serving on boards, HOA/co-op participation, and building online communities around shared purpose.
**Why required:** Impact through collective action and institutional participation. Distinct from individual service (RA1) — this is about building/sustaining the structures that enable collective well-being.
**Boundary:** Excludes purely social/recreational group membership (that's social/relationship dimensions). The community involvement must have a purpose beyond personal enjoyment.

### RA5 — Philanthropy & Financial Giving
**Scope:** Using financial resources to create impact. Includes charitable donations, impact investing, funding causes, sponsoring individuals (scholarships, bail funds), effective altruism-style giving, and setting up foundations or donor-advised funds.
**Why required:** For many people, especially those with more financial than time resources, giving is a primary impact channel. It's categorically different from time-based contribution.
**Boundary:** Excludes lending/investing primarily for financial return (that's a financial dimension). The primary intent must be impact, not profit.

### RA6 — Environmental Stewardship
**Scope:** Actions to protect, restore, or sustain the natural environment. Includes personal sustainability practices (reducing waste, energy conservation), environmental activism, conservation work, habitat restoration, and advocacy for environmental policy.
**Why required:** Environmental impact is a distinct category from social impact — different skills, different metrics, different communities. Lumping it under "volunteering" loses important nuance.
**Boundary:** Excludes environmental practices motivated purely by cost savings. The intent must include environmental benefit.

### RA7 — Legacy & Long-term Contribution
**Scope:** Actions oriented toward impact that persists beyond one's active involvement or lifetime. Includes estate planning for charitable purposes, building institutions or organizations meant to outlast you, creating enduring works (art, infrastructure, policy), documenting family/cultural history, and succession planning for impact projects.
**Why required:** Addresses the time dimension of impact — not just "how much" but "how lasting." Many people care deeply about what they leave behind.
**Boundary:** Excludes day-to-day impact activities (covered by other RAs). This is specifically about the durability and persistence of contribution.

### RA8 — Advocacy & Social Justice
**Scope:** Working to change systems, policies, or cultural norms to reduce injustice and improve conditions for disadvantaged groups. Includes campaigning for policy change, raising awareness of social issues, supporting marginalized communities, fighting discrimination, and participating in movements for equity.
**Why required:** Systemic change is a distinct impact strategy from individual service or giving. It targets root causes rather than symptoms.
**Boundary:** Overlaps with RA4 (civic participation) but is more specific — RA4 covers general community governance, RA8 covers justice-oriented change. A dimension can satisfy both if its description covers both scopes.

### RA9 — Professional & Workplace Impact
**Scope:** Using one's professional role to create positive impact beyond the job description. Includes ethical leadership, creating inclusive workplaces, corporate social responsibility initiatives, pro bono professional services, social entrepreneurship, and building businesses that solve social problems.
**Why required:** Most people spend the majority of their waking hours at work. Professional impact is where many people have the most leverage but it's often overlooked in personal development frameworks.
**Boundary:** Excludes career advancement for its own sake (that's a career dimension). The focus is on the externally-directed impact of professional activity.

### RA10 — Caregiving & Family Support
**Scope:** Providing care, support, and stability to family members and dependents. Includes eldercare, childcare beyond basic parenting duties, supporting family members through illness or hardship, and maintaining family cohesion across generations.
**Why required:** For many people, their most significant daily impact is within their family. Caregiving is often invisible in impact frameworks despite being enormously valuable.
**Boundary:** Excludes routine social relationships (that's a relationships dimension). This specifically covers care-oriented, often asymmetric support relationships.

---

## Coverage Completeness Criteria

### CC1 — All Required Areas Addressed
Every RA above must be covered by at least one dimension in `smind_life_dimensions`. A single dimension may cover multiple RAs if its description explicitly addresses all covered scopes.

### CC2 — No Orphan Impact Activities
The following common impact activities must each be coverable by at least one dimension:
- Donating blood/organs
- Signing petitions
- Jury duty
- Being a designated driver
- Emotional support for friends in crisis
- Reporting safety hazards
- Translating for non-native speakers

If any of these cannot be placed under an existing dimension, there's a coverage gap.

### CC3 — Scale Spectrum
The dimension set should cover impact at multiple scales:
- **Individual** (helping one person)
- **Community** (local group/neighborhood)
- **Societal** (regional/national policy or culture)
- **Global** (international, species-level, planetary)

Not every dimension needs to cover all scales, but the full set collectively should.

### CC4 — Modality Spectrum
The dimension set should cover multiple modalities of impact:
- **Time** (volunteering, mentoring)
- **Money** (giving, investing)
- **Knowledge** (teaching, publishing)
- **Influence** (advocacy, leadership)
- **Care** (caregiving, emotional support)

Again, collective coverage across all dimensions, not per-dimension.

---

## Evaluator Instructions

1. For each RA (RA1–RA10), check if at least one dimension in `smind_life_dimensions` covers it. "Covers" means the dimension's `name` + `description` clearly addresses the RA's scope.
2. Run the CC2 activity test — try to place each listed activity. Flag any that can't be placed.
3. Check CC3 and CC4 by reviewing the full dimension set for scale and modality coverage.
4. File GitHub issues for any gaps found, referencing the specific RA or CC that's unmet.

---

*Benchmark created: 2026-02-20*
*Next review: Improve by adding nuance to boundaries, expanding CC2 activity list, and considering cultural variation in impact definitions.*
