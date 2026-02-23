# Health Dimensions Benchmark

> Defines what life dimensions should exist in `smind_life_dimensions` to comprehensively cover **Health** — physical and mental wellbeing, medical care, longevity, and all aspects of bodily health.
>
> **Version:** 1.0 (2026-02-20)
> **Consumer:** Evaluator job (LLM). Criteria are designed to be concrete and actionable.

---

## How to Use This Benchmark

The Evaluator should check that `smind_life_dimensions` contains dimensions (or clearly scoped sub-dimensions) covering **every area** listed below. A dimension "covers" an area if its `name` + `description` unambiguously includes that area's scope. Partial or vague overlap does not count.

---

## Required Coverage Areas

### 1. Physical Fitness & Exercise

**Must cover:** Cardiovascular/aerobic fitness, strength/resistance training, flexibility/mobility, balance and coordination, body composition.

**Why separate from general health:** Fitness is actionable and measurable (VO2max, strength PRs, flexibility benchmarks). Lumping it into a generic "health" dimension loses specificity.

**Evaluator check:** At least one dimension whose description explicitly mentions physical fitness, exercise, or training.

---

### 2. Nutrition & Diet

**Must cover:** Macronutrient balance, micronutrient adequacy, hydration, dietary patterns/habits, food quality, relationship with food (e.g., emotional eating, restrictions).

**Why distinct:** Nutrition is a daily behavioral domain with its own metrics (calorie tracking, blood glucose, deficiency panels). It drives outcomes in nearly every other health area but requires its own goal-setting.

**Evaluator check:** At least one dimension explicitly addressing nutrition, diet, or eating habits.

---

### 3. Sleep & Recovery

**Must cover:** Sleep duration, sleep quality/architecture (deep sleep, REM), sleep hygiene habits, circadian rhythm alignment, daytime recovery and rest practices, napping.

**Why distinct:** Sleep is the single highest-leverage health behavior. It has its own measurement ecosystem (wearables, sleep studies) and its own intervention set (sleep hygiene, CBT-I, light exposure).

**Evaluator check:** At least one dimension explicitly addressing sleep or sleep quality.

---

### 4. Mental Health & Emotional Wellbeing

**Must cover:** Mood regulation, anxiety management, depression screening, stress resilience, emotional processing, self-esteem, psychological safety, trauma awareness.

**Why distinct:** Mental health is not merely the absence of mental illness. It requires proactive monitoring and has distinct interventions (therapy, journaling, medication, social connection).

**Evaluator check:** At least one dimension explicitly addressing mental health, emotional wellbeing, or psychological health.

---

### 5. Stress Management

**Must cover:** Chronic stress identification, acute stress coping strategies, physiological stress markers (cortisol, HRV), burnout prevention, relaxation techniques, work-life balance as it relates to health.

**Why potentially distinct from mental health:** Stress is a physiological phenomenon with measurable biomarkers. While related to mental health, its interventions (breathing exercises, HRV training, workload management) and metrics are distinct enough to warrant explicit coverage.

**Evaluator check:** Stress management must be explicitly mentioned — either as its own dimension or clearly within the scope of another dimension's description. Implicit coverage is insufficient.

---

### 6. Medical Care & Healthcare Access

**Must cover:** Preventive screenings (cancer, cardiovascular, metabolic), routine check-ups, dental care, vision/hearing care, vaccinations, relationship with healthcare providers, health insurance/access, specialist care when needed.

**Why distinct:** This is the "system interaction" layer — how the person engages with the healthcare system. It's about compliance with recommended screenings, maintaining provider relationships, and navigating access.

**Evaluator check:** At least one dimension addressing medical care, preventive screenings, or healthcare engagement.

---

### 7. Chronic Disease Prevention & Management

**Must cover:** Cardiovascular disease risk factors (blood pressure, cholesterol, blood glucose), metabolic health (insulin sensitivity, body weight management), cancer risk reduction, autoimmune conditions, genetic risk awareness, family medical history tracking.

**Why distinct from medical care:** Medical care is about system engagement; this is about the substantive health risks being monitored and managed. A person can attend all check-ups but ignore metabolic syndrome.

**Evaluator check:** At least one dimension addressing chronic disease prevention, metabolic health, or long-term disease risk management.

---

### 8. Substance Use & Addictive Behaviors

**Must cover:** Alcohol consumption patterns, tobacco/nicotine use, recreational drug use, caffeine dependency, behavioral addictions (gambling, screens) as they affect health, medication dependency.

**Why distinct:** Substance use is a major health determinant that people under-report and systems under-track. It requires honest self-assessment and has specific intervention pathways.

**Evaluator check:** At least one dimension explicitly addressing substance use, addiction, or consumption habits that affect health.

---

### 9. Sexual & Reproductive Health

**Must cover:** STI prevention/screening, contraception (if applicable), reproductive planning, sexual function and satisfaction, hormonal health (testosterone, estrogen, thyroid as it relates to reproductive health), menopause/andropause awareness.

**Why distinct:** Often overlooked in "health" taxonomies due to cultural discomfort. It has its own screening schedules, specialists, and intervention sets.

**Evaluator check:** At least one dimension explicitly addressing sexual health, reproductive health, or hormonal health.

---

### 10. Longevity & Biological Aging

**Must cover:** Biological age vs. chronological age, longevity biomarkers (telomere length, epigenetic clocks, inflammatory markers), anti-aging interventions (caloric restriction, senolytics awareness), healthspan optimization (not just lifespan).

**Why distinct:** Longevity science is a rapidly growing field with its own metrics and interventions. A health taxonomy that only addresses disease is incomplete — it should also address proactive aging optimization.

**Evaluator check:** At least one dimension addressing longevity, aging, biological age, or healthspan.

---

### 11. Pain Management & Physical Rehabilitation

**Must cover:** Acute pain management, chronic pain conditions, injury recovery and rehabilitation, physical therapy engagement, ergonomics (posture, workstation setup), musculoskeletal health.

**Why distinct:** Pain is the #1 reason people seek medical care. Chronic pain has its own treatment ecosystem and profoundly affects quality of life. Injury recovery is a distinct health phase requiring specific attention.

**Evaluator check:** At least one dimension addressing pain management, physical rehabilitation, or musculoskeletal health.

---

### 12. Immune System & Illness Resilience

**Must cover:** Immune function optimization, infection prevention (hygiene, vaccination), recovery from acute illness, autoimmune awareness, allergy management, gut microbiome health.

**Why distinct:** The immune system is a distinct physiological system with its own optimization levers (sleep, nutrition, stress management, probiotics) and failure modes (frequent illness, autoimmunity, allergies).

**Evaluator check:** At least one dimension addressing immune health, illness prevention, or immune resilience.

---

### 13. Environmental & Occupational Health

**Must cover:** Air quality exposure, water quality, toxic substance exposure (household chemicals, workplace hazards), noise pollution, sun/UV exposure management, ergonomic environment.

**Why often missed:** People optimize diet and exercise while ignoring that they breathe polluted air or sit in ergonomically terrible setups for 10 hours daily. Environmental factors are high-leverage but low-salience.

**Evaluator check:** At least one dimension addressing environmental health factors or occupational health hazards.

---

### 14. Oral Health

**Must cover:** Dental hygiene habits, regular dental check-ups, gum disease prevention, orthodontic concerns, oral-systemic health connection (periodontitis → cardiovascular risk).

**Why distinct:** Oral health is systemically important but almost always siloed. It has its own provider system, its own habits, and proven links to cardiovascular and metabolic disease.

**Evaluator check:** Oral health must be explicitly mentioned — either as its own dimension or clearly within the scope of another dimension's description.

---

### 15. Health Literacy & Self-Advocacy

**Must cover:** Understanding of one's own health data (lab results, vitals), ability to research and evaluate health information, medical decision-making capacity, communication with healthcare providers, health record management.

**Why distinct:** A meta-skill that determines effectiveness across all other health dimensions. Someone with low health literacy will under-utilize every other health resource.

**Evaluator check:** At least one dimension addressing health literacy, health self-advocacy, or health information management.

---

## Completeness Criteria

A **comprehensive** health dimension set must:

1. **Cover all 15 areas above** — each area must map to at least one dimension.
2. **Avoid excessive lumping** — a single dimension called "Health" covering everything is not comprehensive. At minimum, physical health, mental health, nutrition, sleep, and medical care should be distinguishable.
3. **Allow granular goal-setting** — dimensions should be specific enough that a Smart Goal Creator can generate actionable goals for each one.
4. **No orphan areas** — every area above must be traceable to at least one dimension. The Evaluator should flag any area that cannot be mapped.

## Scoring Guidance for Evaluator

| Coverage | Score |
|----------|-------|
| 14-15 areas covered | Excellent — minor gaps only |
| 11-13 areas covered | Good — notable gaps to file |
| 7-10 areas covered | Fair — significant restructuring needed |
| <7 areas covered | Poor — major overhaul required |

When filing issues, prioritize by health impact: Mental Health, Sleep, Nutrition, and Chronic Disease Prevention are highest-impact gaps if missing.
