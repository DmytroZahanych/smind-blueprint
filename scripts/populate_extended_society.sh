#!/bin/bash
# Populate smind_society_extended with dimension evaluator jobs
# and smind_society with extended members

set -euo pipefail

SUPABASE_URL="${SUPABASE_URL}"
SUPABASE_SERVICE_KEY="${SUPABASE_SERVICE_KEY}"

# Helper: insert member into smind_society
add_member() {
  local name="$1"
  local description="$2"
  curl -s "$SUPABASE_URL/rest/v1/smind_society" \
    -H "apikey: $SUPABASE_SERVICE_KEY" \
    -H "Authorization: Bearer $SUPABASE_SERVICE_KEY" \
    -H "Content-Type: application/json" \
    -H "Prefer: resolution=merge-duplicates" \
    -d "{\"name\": $(echo "$name" | jq -Rs .), \"description\": $(echo "$description" | jq -Rs .), \"type\": \"extended\"}" > /dev/null
}

# Helper: insert job into smind_society_extended
add_job() {
  local job_name="$1"
  local member="$2"
  local instructions="$3"
  curl -s "$SUPABASE_URL/rest/v1/smind_society_extended" \
    -H "apikey: $SUPABASE_SERVICE_KEY" \
    -H "Authorization: Bearer $SUPABASE_SERVICE_KEY" \
    -H "Content-Type: application/json" \
    -H "Prefer: resolution=merge-duplicates" \
    -d "{\"job_name\": $(echo "$job_name" | jq -Rs .), \"member\": $(echo "$member" | jq -Rs .), \"enabled\": true, \"instructions\": $(echo "$instructions" | jq -Rs .)}" > /dev/null
}

TEMPLATE_REF="smart_goals_dimension_evaluator"
INSTRUCTIONS_PREFIX="This is an extended society dimension evaluator job. Pull the template job instructions from \`smind_society_core_jobs\` where \`job_name = '${TEMPLATE_REF}'\` and execute them with the following parameter:"

# ============================================================
# TIER 1 — IMMEDIATE
# ============================================================

# 1.1 Nutrition & Diet
add_member "Nutrition & Diet Evaluator" "Evaluates smart goal coverage for the Nutrition & Diet life dimension (Tier 1). Identifies missing goals for sugar elimination, fasting, lactose avoidance, caloric quality, hydration, meal planning, and food source optimization."
add_job "dimension_evaluator_1_1" "Nutrition & Diet Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1 Nutrition & Diet (Tier 1)
SCOPE: Sugar/sweets elimination, intermittent fasting restoration, lactose avoidance, overall caloric quality, hydration habits, kitchen environment design, meal planning within fasting window, food source optimization (Uber Eats dependency).
ARTIFACT: society/smart_goals/score_coverage_1_1.md"

# 1.1 subdimensions
add_member "Sugar Elimination Evaluator" "Evaluates smart goal coverage for sugar/sweets elimination (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_sugar" "Sugar Elimination Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.1 Sugar/Sweets Elimination (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: Target zero daily sweets, stress-eating sugar triggers, replacement strategies, progress tracking.
ARTIFACT: society/smart_goals/score_coverage_1_1_sugar.md"

add_member "Intermittent Fasting Evaluator" "Evaluates smart goal coverage for intermittent fasting restoration (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_fasting" "Intermittent Fasting Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.2 Intermittent Fasting Restoration (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: 6h eating window (12pm-6pm), restoration of pre-displacement fasting routine, compliance tracking.
ARTIFACT: society/smart_goals/score_coverage_1_1_fasting.md"

add_member "Lactose Avoidance Evaluator" "Evaluates smart goal coverage for lactose avoidance (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_lactose" "Lactose Avoidance Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.3 Lactose Avoidance (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: Lactose intolerance management, dairy alternatives, awareness of hidden lactose in food.
ARTIFACT: society/smart_goals/score_coverage_1_1_lactose.md"

add_member "Caloric Quality Evaluator" "Evaluates smart goal coverage for overall caloric quality (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_caloric" "Caloric Quality Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.4 Overall Caloric Quality (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: Nutritional density beyond restriction, macronutrient balance, food quality vs quantity.
ARTIFACT: society/smart_goals/score_coverage_1_1_caloric.md"

add_member "Hydration Evaluator" "Evaluates smart goal coverage for hydration habits (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_hydration" "Hydration Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.5 Hydration Habits (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: Daily water intake, hydration tracking, integration with fasting window.
ARTIFACT: society/smart_goals/score_coverage_1_1_hydration.md"

add_member "Kitchen Environment Evaluator" "Evaluates smart goal coverage for kitchen environment design (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_kitchen" "Kitchen Environment Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.6 Kitchen Environment Design (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: Light OFF after 6pm behavioral cue, food availability management, environmental triggers.
ARTIFACT: society/smart_goals/score_coverage_1_1_kitchen.md"

add_member "Meal Planning Evaluator" "Evaluates smart goal coverage for meal planning within fasting window (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_meals" "Meal Planning Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.7 Meal Planning Within Fasting Window (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: Nutritional density in 6h window, meal preparation, planning ahead.
ARTIFACT: society/smart_goals/score_coverage_1_1_meals.md"

add_member "Food Source Evaluator" "Evaluates smart goal coverage for food source optimization (subdimension of 1.1 Nutrition)."
add_job "dimension_evaluator_1_1_food_source" "Food Source Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.1.8 Food Source Optimization (Tier 1, subdimension of 1.1 Nutrition & Diet)
SCOPE: Uber Eats dependency, healthier ordering patterns, cooking transition.
ARTIFACT: society/smart_goals/score_coverage_1_1_food_source.md"

# 1.2 Physical Movement
add_member "Physical Movement Evaluator" "Evaluates smart goal coverage for the Physical Movement life dimension (Tier 1)."
add_job "dimension_evaluator_1_2" "Physical Movement Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.2 Physical Movement (Tier 1)
SCOPE: Daily walking habit, breaking sedentary blocks, strength/resistance training, step tracking feedback loop.
ARTIFACT: society/smart_goals/score_coverage_1_2.md"

add_member "Daily Walking Evaluator" "Evaluates smart goal coverage for daily walking habit (subdimension of 1.2 Movement)."
add_job "dimension_evaluator_1_2_walking" "Daily Walking Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.2.1 Daily Walking Habit (Tier 1, subdimension of 1.2 Physical Movement)
SCOPE: 30 min daily, waterfront preferred, 7000+ step target, post-surgery clearance from Feb 22.
ARTIFACT: society/smart_goals/score_coverage_1_2_walking.md"

add_member "Sedentary Breaks Evaluator" "Evaluates smart goal coverage for breaking sedentary blocks (subdimension of 1.2 Movement)."
add_job "dimension_evaluator_1_2_sedentary" "Sedentary Breaks Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.2.2 Breaking Sedentary Blocks (Tier 1, subdimension of 1.2 Physical Movement)
SCOPE: Movement every 60-90 min during work, 8-10h sedentary daily problem.
ARTIFACT: society/smart_goals/score_coverage_1_2_sedentary.md"

add_member "Strength Training Evaluator" "Evaluates smart goal coverage for strength/resistance training (subdimension of 1.2 Movement)."
add_job "dimension_evaluator_1_2_strength" "Strength Training Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.2.3 Strength/Resistance Training (Tier 1, subdimension of 1.2 Physical Movement)
SCOPE: Eventual strength training for longevity, progressive introduction.
ARTIFACT: society/smart_goals/score_coverage_1_2_strength.md"

add_member "Step Tracking Evaluator" "Evaluates smart goal coverage for step tracking feedback loop (subdimension of 1.2 Movement)."
add_job "dimension_evaluator_1_2_steps" "Step Tracking Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.2.4 Step Tracking Feedback Loop (Tier 1, subdimension of 1.2 Physical Movement)
SCOPE: Withings/HealthKit data, avg 2500 steps vs 7000+ target, tracking accountability.
ARTIFACT: society/smart_goals/score_coverage_1_2_steps.md"

# 1.3 Sleep Quality
add_member "Sleep Quality Evaluator" "Evaluates smart goal coverage for the Sleep Quality life dimension (Tier 1)."
add_job "dimension_evaluator_1_3" "Sleep Quality Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.3 Sleep Quality (Tier 1)
SCOPE: Sleep schedule consistency, pre-sleep wind-down, sleep apnea investigation, sleep environment, objective tracking.
ARTIFACT: society/smart_goals/score_coverage_1_3.md"

add_member "Sleep Schedule Evaluator" "Evaluates smart goal coverage for sleep schedule consistency (subdimension of 1.3 Sleep)."
add_job "dimension_evaluator_1_3_schedule" "Sleep Schedule Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.3.1 Sleep Schedule Consistency (Tier 1, subdimension of 1.3 Sleep Quality)
SCOPE: 7am wake, 10pm bed target, consistency tracking.
ARTIFACT: society/smart_goals/score_coverage_1_3_schedule.md"

add_member "Pre-Sleep Routine Evaluator" "Evaluates smart goal coverage for pre-sleep wind-down routine (subdimension of 1.3 Sleep)."
add_job "dimension_evaluator_1_3_winddown" "Pre-Sleep Routine Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.3.2 Pre-Sleep Wind-Down Routine (Tier 1, subdimension of 1.3 Sleep Quality)
SCOPE: 9-10pm wind-down routine, screen reduction, relaxation activities.
ARTIFACT: society/smart_goals/score_coverage_1_3_winddown.md"

add_member "Sleep Apnea Evaluator" "Evaluates smart goal coverage for sleep apnea investigation (subdimension of 1.3 Sleep)."
add_job "dimension_evaluator_1_3_apnea" "Sleep Apnea Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.3.3 Sleep Apnea Investigation (Tier 1, subdimension of 1.3 Sleep Quality)
SCOPE: Snoring as red flag, sleep study scheduling, screening.
ARTIFACT: society/smart_goals/score_coverage_1_3_apnea.md"

add_member "Sleep Environment Evaluator" "Evaluates smart goal coverage for sleep environment optimization (subdimension of 1.3 Sleep)."
add_job "dimension_evaluator_1_3_environment" "Sleep Environment Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.3.4 Sleep Environment Optimization (Tier 1, subdimension of 1.3 Sleep Quality)
SCOPE: Room temperature, darkness, noise, bedding, device removal.
ARTIFACT: society/smart_goals/score_coverage_1_3_environment.md"

add_member "Sleep Tracking Evaluator" "Evaluates smart goal coverage for objective sleep tracking (subdimension of 1.3 Sleep)."
add_job "dimension_evaluator_1_3_tracking" "Sleep Tracking Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.3.5 Objective Sleep Tracking (Tier 1, subdimension of 1.3 Sleep Quality)
SCOPE: Planned Withings sleep tracker purchase, data integration.
ARTIFACT: society/smart_goals/score_coverage_1_3_tracking.md"

# 1.4 Supplementation
add_member "Supplementation Evaluator" "Evaluates smart goal coverage for the Supplementation & Deficiency Correction life dimension (Tier 1)."
add_job "dimension_evaluator_1_4" "Supplementation Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.4 Supplementation & Deficiency Correction (Tier 1)
SCOPE: Vitamin D, folic acid, Cicaplast wound care, future reassessment.
ARTIFACT: society/smart_goals/score_coverage_1_4.md"

add_member "Vitamin D Evaluator" "Evaluates smart goal coverage for vitamin D supplementation (subdimension of 1.4)."
add_job "dimension_evaluator_1_4_vitamind" "Vitamin D Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.4.1 Vitamin D Daily (Tier 1, subdimension of 1.4 Supplementation)
SCOPE: 2000-4000 IU daily, deficiency level 16.9 ng/mL, compliance tracking.
ARTIFACT: society/smart_goals/score_coverage_1_4_vitamind.md"

add_member "Folic Acid Evaluator" "Evaluates smart goal coverage for folic acid supplementation (subdimension of 1.4)."
add_job "dimension_evaluator_1_4_folic" "Folic Acid Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.4.2 Folic Acid Daily (Tier 1, subdimension of 1.4 Supplementation)
SCOPE: 400 mcg daily, deficiency level 2.6 ng/mL, compliance tracking.
ARTIFACT: society/smart_goals/score_coverage_1_4_folic.md"

add_member "Wound Care Evaluator" "Evaluates smart goal coverage for Cicaplast wound care (subdimension of 1.4)."
add_job "dimension_evaluator_1_4_wound" "Wound Care Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.4.3 Cicaplast Wound Care (Tier 1, subdimension of 1.4 Supplementation)
SCOPE: 2x daily for 6 months until Aug 2026, post-surgery compliance.
ARTIFACT: society/smart_goals/score_coverage_1_4_wound.md"

add_member "Future Reassessment Evaluator" "Evaluates smart goal coverage for future supplement reassessment (subdimension of 1.4)."
add_job "dimension_evaluator_1_4_reassess" "Future Reassessment Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.4.4 Future Reassessment (Tier 1, subdimension of 1.4 Supplementation)
SCOPE: Follow-up blood work May-Jun 2026, reassess based on new levels.
ARTIFACT: society/smart_goals/score_coverage_1_4_reassess.md"

# 1.5 Daily Structure
add_member "Daily Structure Evaluator" "Evaluates smart goal coverage for the Daily Structure & Routine Architecture life dimension (Tier 1)."
add_job "dimension_evaluator_1_5" "Daily Structure Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.5 Daily Structure & Routine Architecture (Tier 1)
SCOPE: Morning anchor, work block structure, evening wind-down, transition rituals, Monday sync accommodation.
ARTIFACT: society/smart_goals/score_coverage_1_5.md"

add_member "Morning Anchor Evaluator" "Evaluates smart goal coverage for morning anchor routine (subdimension of 1.5)."
add_job "dimension_evaluator_1_5_morning" "Morning Anchor Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.5.1 Morning Anchor (Tier 1, subdimension of 1.5 Daily Structure)
SCOPE: Parrot time ~8-9am → hygiene → walk sequence.
ARTIFACT: society/smart_goals/score_coverage_1_5_morning.md"

add_member "Work Blocks Evaluator" "Evaluates smart goal coverage for work block structure (subdimension of 1.5)."
add_job "dimension_evaluator_1_5_work" "Work Blocks Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.5.2 Work Block Structure (Tier 1, subdimension of 1.5 Daily Structure)
SCOPE: 3-6h focus blocks, music, no interruptions, hates <30min boxes.
ARTIFACT: society/smart_goals/score_coverage_1_5_work.md"

add_member "Evening Wind-Down Evaluator" "Evaluates smart goal coverage for evening wind-down (subdimension of 1.5)."
add_job "dimension_evaluator_1_5_evening" "Evening Wind-Down Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.5.3 Evening Wind-Down (Tier 1, subdimension of 1.5 Daily Structure)
SCOPE: Pre-sleep routine 9-10pm, transition from activity to rest.
ARTIFACT: society/smart_goals/score_coverage_1_5_evening.md"

add_member "Transition Rituals Evaluator" "Evaluates smart goal coverage for transition rituals between blocks (subdimension of 1.5)."
add_job "dimension_evaluator_1_5_transitions" "Transition Rituals Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.5.4 Transition Rituals (Tier 1, subdimension of 1.5 Daily Structure)
SCOPE: Rituals between work/rest/activity blocks, preventing context-switch paralysis.
ARTIFACT: society/smart_goals/score_coverage_1_5_transitions.md"

add_member "Monday Sync Evaluator" "Evaluates smart goal coverage for Monday sync accommodation (subdimension of 1.5)."
add_job "dimension_evaluator_1_5_monday" "Monday Sync Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 1.5.5 Monday Sync Accommodation (Tier 1, subdimension of 1.5 Daily Structure)
SCOPE: Weekly 16:00-19:00 UTC blocked, schedule around it.
ARTIFACT: society/smart_goals/score_coverage_1_5_monday.md"

# ============================================================
# TIER 2 — MEDIUM-TERM
# ============================================================

# 2.1 Cardiovascular
add_member "Cardiovascular Risk Evaluator" "Evaluates smart goal coverage for cardiovascular risk reduction (Tier 2)."
add_job "dimension_evaluator_2_1" "Cardiovascular Risk Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.1 Cardiovascular Risk Reduction (Tier 2)
SCOPE: Lipid panel follow-up, diet-based cholesterol reduction, exercise-based reduction, statin decision point.
ARTIFACT: society/smart_goals/score_coverage_2_1.md"

add_member "Lipid Panel Evaluator" "Evaluates smart goal coverage for lipid panel follow-up (subdimension of 2.1)."
add_job "dimension_evaluator_2_1_lipid" "Lipid Panel Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.1.1 Lipid Panel Follow-Up (Tier 2, subdimension of 2.1 Cardiovascular)
SCOPE: Target May-Jun 2026, LDL 233 baseline, tracking improvement.
ARTIFACT: society/smart_goals/score_coverage_2_1_lipid.md"

add_member "Diet Cholesterol Evaluator" "Evaluates smart goal coverage for diet-based cholesterol reduction (subdimension of 2.1)."
add_job "dimension_evaluator_2_1_diet_chol" "Diet Cholesterol Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.1.2 Diet-Based Cholesterol Reduction (Tier 2, subdimension of 2.1 Cardiovascular)
SCOPE: Sugar/cholesterol directly drives LDL, dietary intervention.
ARTIFACT: society/smart_goals/score_coverage_2_1_diet_chol.md"

add_member "Exercise Cholesterol Evaluator" "Evaluates smart goal coverage for exercise-based cholesterol reduction (subdimension of 2.1)."
add_job "dimension_evaluator_2_1_exercise_chol" "Exercise Cholesterol Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.1.3 Exercise-Based Cholesterol Reduction (Tier 2, subdimension of 2.1 Cardiovascular)
SCOPE: Movement contribution to lipid improvement.
ARTIFACT: society/smart_goals/score_coverage_2_1_exercise_chol.md"

add_member "Statin Decision Evaluator" "Evaluates smart goal coverage for medication decision point (subdimension of 2.1)."
add_job "dimension_evaluator_2_1_statin" "Statin Decision Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.1.4 Medication Decision Point (Tier 2, subdimension of 2.1 Cardiovascular)
SCOPE: Statin consideration if lifestyle insufficient after retest.
ARTIFACT: society/smart_goals/score_coverage_2_1_statin.md"

# 2.2 Weight Management
add_member "Weight Management Evaluator" "Evaluates smart goal coverage for weight management (Tier 2)."
add_job "dimension_evaluator_2_2" "Weight Management Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.2 Weight Management (Tier 2)
SCOPE: 82.6kg→70kg target, caloric deficit, movement contribution, tracking, milestones.
ARTIFACT: society/smart_goals/score_coverage_2_2.md"

add_member "Caloric Deficit Evaluator" "Evaluates smart goal coverage for caloric deficit via diet + fasting (subdimension of 2.2)."
add_job "dimension_evaluator_2_2_deficit" "Caloric Deficit Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.2.1 Caloric Deficit (Tier 2, subdimension of 2.2 Weight Management)
SCOPE: Diet restructuring + fasting window for deficit.
ARTIFACT: society/smart_goals/score_coverage_2_2_deficit.md"

add_member "Weight Tracking Evaluator" "Evaluates smart goal coverage for weight tracking/accountability (subdimension of 2.2)."
add_job "dimension_evaluator_2_2_tracking" "Weight Tracking Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.2.2 Weight Tracking/Accountability (Tier 2, subdimension of 2.2 Weight Management)
SCOPE: Withings scale, realistic milestones 0.5-1 kg/week.
ARTIFACT: society/smart_goals/score_coverage_2_2_tracking.md"

# 2.3 Medical & Preventive
add_member "Medical Preventive Evaluator" "Evaluates smart goal coverage for medical & preventive healthcare (Tier 2)."
add_job "dimension_evaluator_2_3" "Medical Preventive Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3 Medical & Preventive Healthcare (Tier 2)
SCOPE: Check-up cadence, dental, allergies, chronic issues, post-surgery, blood work, massage.
ARTIFACT: society/smart_goals/score_coverage_2_3.md"

add_member "Dental Health Evaluator" "Evaluates smart goal coverage for dental health (subdimension of 2.3)."
add_job "dimension_evaluator_2_3_dental" "Dental Health Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3.1 Dental Health (Tier 2, subdimension of 2.3 Medical)
SCOPE: Dental phobia, general anesthesia solution for wisdom teeth removal.
ARTIFACT: society/smart_goals/score_coverage_2_3_dental.md"

add_member "Allergy Management Evaluator" "Evaluates smart goal coverage for allergy management (subdimension of 2.3)."
add_job "dimension_evaluator_2_3_allergy" "Allergy Management Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3.2 Allergy Management (Tier 2, subdimension of 2.3 Medical)
SCOPE: Pollen, dust, walnuts, seasonal antihistamines.
ARTIFACT: society/smart_goals/score_coverage_2_3_allergy.md"

add_member "Post-Surgery Evaluator" "Evaluates smart goal coverage for post-surgery follow-up (subdimension of 2.3)."
add_job "dimension_evaluator_2_3_surgery" "Post-Surgery Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3.3 Post-Surgery Follow-Up (Tier 2, subdimension of 2.3 Medical)
SCOPE: Cyst removal Jan 31, stitches removed Feb 13, plastic surgery consult Feb 16, Cicaplast regimen.
ARTIFACT: society/smart_goals/score_coverage_2_3_surgery.md"

add_member "Blood Work Evaluator" "Evaluates smart goal coverage for follow-up blood work (subdimension of 2.3)."
add_job "dimension_evaluator_2_3_bloodwork" "Blood Work Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3.4 Follow-Up Blood Work (Tier 2, subdimension of 2.3 Medical)
SCOPE: Schedule May-Jun 2026, compare against Apr 2025 baseline.
ARTIFACT: society/smart_goals/score_coverage_2_3_bloodwork.md"

add_member "Chronic Issues Evaluator" "Evaluates smart goal coverage for chronic issues investigation (subdimension of 2.3)."
add_job "dimension_evaluator_2_3_chronic" "Chronic Issues Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3.5 Chronic Issues Investigation (Tier 2, subdimension of 2.3 Medical)
SCOPE: Red facial skin, foot acne, running nose — investigation and management.
ARTIFACT: society/smart_goals/score_coverage_2_3_chronic.md"

add_member "Massage Therapy Evaluator" "Evaluates smart goal coverage for massage sessions (subdimension of 2.3)."
add_job "dimension_evaluator_2_3_massage" "Massage Therapy Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3.6 Massage Sessions (Tier 2, subdimension of 2.3 Medical)
SCOPE: Biannual for headache prevention, muscular tension in left shoulder.
ARTIFACT: society/smart_goals/score_coverage_2_3_massage.md"

add_member "Check-Up Cadence Evaluator" "Evaluates smart goal coverage for regular check-up cadence (subdimension of 2.3)."
add_job "dimension_evaluator_2_3_checkups" "Check-Up Cadence Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.3.7 Regular Check-Up Cadence (Tier 2, subdimension of 2.3 Medical)
SCOPE: GP access via SNS, establishing regular visit schedule.
ARTIFACT: society/smart_goals/score_coverage_2_3_checkups.md"

# 2.4 Immigration
add_member "Immigration Evaluator" "Evaluates smart goal coverage for immigration & legal (Tier 2)."
add_job "dimension_evaluator_2_4" "Immigration Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.4 Immigration & Legal (Tier 2)
SCOPE: AIMA appointment Mar 12, document prep, travel logistics, Nastya's 89.2 process.
ARTIFACT: society/smart_goals/score_coverage_2_4.md"

add_member "AIMA Preparation Evaluator" "Evaluates smart goal coverage for AIMA appointment preparation (subdimension of 2.4)."
add_job "dimension_evaluator_2_4_aima" "AIMA Preparation Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.4.1 AIMA Appointment Preparation (Tier 2, subdimension of 2.4 Immigration)
SCOPE: Document checklist ~90% ready, 4 items remain, March 12 Faro appointment.
ARTIFACT: society/smart_goals/score_coverage_2_4_aima.md"

add_member "Nastya Immigration Evaluator" "Evaluates smart goal coverage for Nastya's Article 89.2 process (subdimension of 2.4)."
add_job "dimension_evaluator_2_4_nastya" "Nastya Immigration Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.4.2 Nastya's Article 89.2 Process (Tier 2, subdimension of 2.4 Immigration)
SCOPE: Needs invoices showing minimum income, separate process support.
ARTIFACT: society/smart_goals/score_coverage_2_4_nastya.md"

# 2.5 Mental Health
add_member "Mental Health Evaluator" "Evaluates smart goal coverage for mental health & stress management (Tier 2)."
add_job "dimension_evaluator_2_5" "Mental Health Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.5 Mental Health & Stress Management (Tier 2)
SCOPE: Stress coping alternatives, social battery, trauma processing, turbulence fear, displacement grief.
ARTIFACT: society/smart_goals/score_coverage_2_5.md"

add_member "Stress Coping Evaluator" "Evaluates smart goal coverage for stress coping alternatives to food (subdimension of 2.5)."
add_job "dimension_evaluator_2_5_stress" "Stress Coping Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.5.1 Stress Coping Alternatives (Tier 2, subdimension of 2.5 Mental Health)
SCOPE: Non-food coping strategies, trigger awareness, replacement behaviors.
ARTIFACT: society/smart_goals/score_coverage_2_5_stress.md"

add_member "Social Battery Evaluator" "Evaluates smart goal coverage for social battery management (subdimension of 2.5)."
add_job "dimension_evaluator_2_5_social" "Social Battery Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.5.2 Social Battery Management (Tier 2, subdimension of 2.5 Mental Health)
SCOPE: Tiny battery, depletes rapidly in groups, intentional energy management.
ARTIFACT: society/smart_goals/score_coverage_2_5_social.md"

add_member "Trauma Processing Evaluator" "Evaluates smart goal coverage for trauma processing (subdimension of 2.5)."
add_job "dimension_evaluator_2_5_trauma" "Trauma Processing Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.5.3 Trauma Processing (Tier 2, subdimension of 2.5 Mental Health)
SCOPE: War displacement 2022, therapy consideration, family separation across countries.
ARTIFACT: society/smart_goals/score_coverage_2_5_trauma.md"

add_member "Turbulence Fear Evaluator" "Evaluates smart goal coverage for turbulence fear management (subdimension of 2.5)."
add_job "dimension_evaluator_2_5_turbulence" "Turbulence Fear Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.5.4 Turbulence Fear Management (Tier 2, subdimension of 2.5 Mental Health)
SCOPE: 2023 Pacific flight incident, PTSD affecting travel.
ARTIFACT: society/smart_goals/score_coverage_2_5_turbulence.md"

# 2.6 Pet Welfare
add_member "Pet Welfare Evaluator" "Evaluates smart goal coverage for pet welfare & veterinary (Tier 2)."
add_job "dimension_evaluator_2_6" "Pet Welfare Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.6 Pet Welfare & Veterinary (Tier 2)
SCOPE: Fifi & Kiki (green cheek conures), mating management, vet cadence, enrichment, travel care.
ARTIFACT: society/smart_goals/score_coverage_2_6.md"

add_member "Parrot Mating Evaluator" "Evaluates smart goal coverage for parrot mating management (subdimension of 2.6)."
add_job "dimension_evaluator_2_6_mating" "Parrot Mating Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.6.1 Mating Management (Tier 2, subdimension of 2.6 Pet Welfare)
SCOPE: Research needed as parrots mature, egg-laying risk for Fifi.
ARTIFACT: society/smart_goals/score_coverage_2_6_mating.md"

add_member "Vet Cadence Evaluator" "Evaluates smart goal coverage for veterinary check-up cadence (subdimension of 2.6)."
add_job "dimension_evaluator_2_6_vet" "Vet Cadence Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.6.2 Veterinary Check-Up Cadence (Tier 2, subdimension of 2.6 Pet Welfare)
SCOPE: No vet visit since acquisition April 2025.
ARTIFACT: society/smart_goals/score_coverage_2_6_vet.md"

add_member "Parrot Enrichment Evaluator" "Evaluates smart goal coverage for parrot enrichment (subdimension of 2.6)."
add_job "dimension_evaluator_2_6_enrichment" "Parrot Enrichment Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.6.3 Enrichment & Socialization (Tier 2, subdimension of 2.6 Pet Welfare)
SCOPE: Enrichment rotation schedule, socialization quality.
ARTIFACT: society/smart_goals/score_coverage_2_6_enrichment.md"

add_member "Parrot Travel Care Evaluator" "Evaluates smart goal coverage for parrot travel care (subdimension of 2.6)."
add_job "dimension_evaluator_2_6_travel" "Parrot Travel Care Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 2.6.4 Travel Care Arrangements (Tier 2, subdimension of 2.6 Pet Welfare)
SCOPE: Currently ad-hoc, no fixed solution for travel periods.
ARTIFACT: society/smart_goals/score_coverage_2_6_travel.md"

# ============================================================
# TIER 3 — LONG-TERM
# ============================================================

# 3.1 Longevity Safety Net
add_member "Longevity Safety Net Evaluator" "Evaluates smart goal coverage for longevity mission: safety net (Tier 3)."
add_job "dimension_evaluator_3_1" "Longevity Safety Net Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.1 Longevity Mission: Safety Net (Tier 3)
SCOPE: Biomarker tracking, risk catalog, automated health data ingestion, emergency preparedness.
ARTIFACT: society/smart_goals/score_coverage_3_1.md"

add_member "Biomarker Tracking Evaluator" "Evaluates smart goal coverage for biomarker tracking system (subdimension of 3.1)."
add_job "dimension_evaluator_3_1_biomarkers" "Biomarker Tracking Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.1.1 Biomarker Tracking System (Tier 3, subdimension of 3.1 Longevity Safety Net)
SCOPE: Withings + blood work + future integrations, trend analysis.
ARTIFACT: society/smart_goals/score_coverage_3_1_biomarkers.md"

add_member "Risk Catalog Evaluator" "Evaluates smart goal coverage for health risk catalog (subdimension of 3.1)."
add_job "dimension_evaluator_3_1_risks" "Risk Catalog Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.1.2 Risk Catalog (Tier 3, subdimension of 3.1 Longevity Safety Net)
SCOPE: Cardiovascular, cancer screening for age 32, metabolic syndrome markers.
ARTIFACT: society/smart_goals/score_coverage_3_1_risks.md"

add_member "Health Data Ingestion Evaluator" "Evaluates smart goal coverage for automated health data ingestion (subdimension of 3.1)."
add_job "dimension_evaluator_3_1_ingestion" "Health Data Ingestion Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.1.3 Automated Health Data Ingestion (Tier 3, subdimension of 3.1 Longevity Safety Net)
SCOPE: SMind integration, Withings API, trend analysis automation.
ARTIFACT: society/smart_goals/score_coverage_3_1_ingestion.md"

add_member "Emergency Preparedness Evaluator" "Evaluates smart goal coverage for emergency preparedness (subdimension of 3.1)."
add_job "dimension_evaluator_3_1_emergency" "Emergency Preparedness Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.1.4 Emergency Preparedness (Tier 3, subdimension of 3.1 Longevity Safety Net)
SCOPE: Appendicitis near-miss 2025, early warning systems.
ARTIFACT: society/smart_goals/score_coverage_3_1_emergency.md"

# 3.2 Longevity Aging
add_member "Aging Slowdown Evaluator" "Evaluates smart goal coverage for longevity mission: aging slowdown (Tier 3)."
add_job "dimension_evaluator_3_2" "Aging Slowdown Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.2 Longevity Mission: Aging Slowdown (Tier 3)
SCOPE: Evidence-based interventions, metabolic age tracking, emerging science, personalized protocol.
ARTIFACT: society/smart_goals/score_coverage_3_2.md"

add_member "Anti-Aging Interventions Evaluator" "Evaluates smart goal coverage for evidence-based anti-aging interventions (subdimension of 3.2)."
add_job "dimension_evaluator_3_2_interventions" "Anti-Aging Interventions Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.2.1 Evidence-Based Interventions (Tier 3, subdimension of 3.2 Aging Slowdown)
SCOPE: Exercise, fasting, sleep, supplements — proven anti-aging techniques.
ARTIFACT: society/smart_goals/score_coverage_3_2_interventions.md"

add_member "Metabolic Age Evaluator" "Evaluates smart goal coverage for metabolic age tracking (subdimension of 3.2)."
add_job "dimension_evaluator_3_2_metabolic" "Metabolic Age Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.2.2 Metabolic Age Tracking (Tier 3, subdimension of 3.2 Aging Slowdown)
SCOPE: Currently 32 chronological/metabolic, maintain or reduce gap.
ARTIFACT: society/smart_goals/score_coverage_3_2_metabolic.md"

# 3.3 Career
add_member "Career Evaluator" "Evaluates smart goal coverage for career & professional development (Tier 3)."
add_job "dimension_evaluator_3_3" "Career Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.3 Career & Professional Development (Tier 3)
SCOPE: Neo/SMind time allocation, success criteria, financial trajectory, risk management, game plan execution.
ARTIFACT: society/smart_goals/score_coverage_3_3.md"

add_member "Career Time Allocation Evaluator" "Evaluates smart goal coverage for time allocation between Neo and SMind (subdimension of 3.3)."
add_job "dimension_evaluator_3_3_time" "Career Time Allocation Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.3.1 Time Allocation Neo vs SMind (Tier 3, subdimension of 3.3 Career)
SCOPE: Working 100% on SMind while paid by Neo, position is brittle.
ARTIFACT: society/smart_goals/score_coverage_3_3_time.md"

add_member "Career Risk Evaluator" "Evaluates smart goal coverage for career risk management (subdimension of 3.3)."
add_job "dimension_evaluator_3_3_risk" "Career Risk Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.3.2 Career Risk Management (Tier 3, subdimension of 3.3 Career)
SCOPE: Position depends on Jeremy's decisions, brittle and tenuous.
ARTIFACT: society/smart_goals/score_coverage_3_3_risk.md"

add_member "Game Plan Evaluator" "Evaluates smart goal coverage for career game plan execution (subdimension of 3.3)."
add_job "dimension_evaluator_3_3_gameplan" "Game Plan Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.3.3 Game Plan Execution (Tier 3, subdimension of 3.3 Career)
SCOPE: Fundraise → prove SMind → pivot company trajectory tracking.
ARTIFACT: society/smart_goals/score_coverage_3_3_gameplan.md"

# 3.4 Financial
add_member "Financial Health Evaluator" "Evaluates smart goal coverage for financial health (Tier 3)."
add_job "dimension_evaluator_3_4" "Financial Health Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.4 Financial Health (Tier 3)
SCOPE: Budget management, income optimization, tax compliance, emergency fund, bank integration.
ARTIFACT: society/smart_goals/score_coverage_3_4.md"

add_member "Budget Management Evaluator" "Evaluates smart goal coverage for budget management (subdimension of 3.4)."
add_job "dimension_evaluator_3_4_budget" "Budget Management Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.4.1 Budget Management (Tier 3, subdimension of 3.4 Financial Health)
SCOPE: Tight budget, Deel primary + NOBLEDRIVE proxy income, tracking.
ARTIFACT: society/smart_goals/score_coverage_3_4_budget.md"

add_member "Tax Compliance Evaluator" "Evaluates smart goal coverage for tax compliance (subdimension of 3.4)."
add_job "dimension_evaluator_3_4_tax" "Tax Compliance Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.4.2 Tax Compliance (Tier 3, subdimension of 3.4 Financial Health)
SCOPE: Monthly Portugal taxes around 8th-11th, quarterly VAT.
ARTIFACT: society/smart_goals/score_coverage_3_4_tax.md"

add_member "Bank Integration Evaluator" "Evaluates smart goal coverage for bank data integration (subdimension of 3.4)."
add_job "dimension_evaluator_3_4_bank" "Bank Integration Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.4.3 Bank Data Integration (Tier 3, subdimension of 3.4 Financial Health)
SCOPE: Millennium bank, wants SMind to track spending, not built yet.
ARTIFACT: society/smart_goals/score_coverage_3_4_bank.md"

# 3.5 Relationships
add_member "Relationship Quality Evaluator" "Evaluates smart goal coverage for relationship quality (Tier 3)."
add_job "dimension_evaluator_3_5" "Relationship Quality Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.5 Relationship Quality (Tier 3)
SCOPE: Nastya quality time, family connections, social circle, supporting Nastya's immigration.
ARTIFACT: society/smart_goals/score_coverage_3_5.md"

add_member "Partner Quality Time Evaluator" "Evaluates smart goal coverage for quality time with Nastya (subdimension of 3.5)."
add_job "dimension_evaluator_3_5_partner" "Partner Quality Time Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.5.1 Quality Time with Nastya (Tier 3, subdimension of 3.5 Relationships)
SCOPE: Married since 2019, intentional quality time despite depleted social battery.
ARTIFACT: society/smart_goals/score_coverage_3_5_partner.md"

add_member "Family Connection Evaluator" "Evaluates smart goal coverage for family connections (subdimension of 3.5)."
add_job "dimension_evaluator_3_5_family" "Family Connection Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.5.2 Family Connections (Tier 3, subdimension of 3.5 Relationships)
SCOPE: Parents + brother Kostya in Germany, maintaining contact across countries.
ARTIFACT: society/smart_goals/score_coverage_3_5_family.md"

add_member "Social Circle Evaluator" "Evaluates smart goal coverage for social circle maintenance (subdimension of 3.5)."
add_job "dimension_evaluator_3_5_social" "Social Circle Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 3.5.3 Social Circle Maintenance (Tier 3, subdimension of 3.5 Relationships)
SCOPE: Small Portugal-based circle — Oleksandr, Ivan, colleagues.
ARTIFACT: society/smart_goals/score_coverage_3_5_social.md"

# ============================================================
# TIER 4 — EXISTENTIAL & META
# ============================================================

# 4.1 Purpose
add_member "Purpose & Mission Evaluator" "Evaluates smart goal coverage for sense of purpose & mission alignment (Tier 4)."
add_job "dimension_evaluator_4_1" "Purpose & Mission Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.1 Sense of Purpose & Mission Alignment (Tier 4)
SCOPE: Longevity mission progress visibility, engagement, scope management, regret mitigation.
ARTIFACT: society/smart_goals/score_coverage_4_1.md"

# 4.2 Environmental Design
add_member "Environmental Design Evaluator" "Evaluates smart goal coverage for environmental design (Tier 4)."
add_job "dimension_evaluator_4_2" "Environmental Design Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.2 Environmental Design (Tier 4)
SCOPE: Home optimization, work environment, digital environment, food availability management.
ARTIFACT: society/smart_goals/score_coverage_4_2.md"

# 4.3 Cognitive Function
add_member "Cognitive Function Evaluator" "Evaluates smart goal coverage for cognitive function & mental performance (Tier 4)."
add_job "dimension_evaluator_4_3" "Cognitive Function Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.3 Cognitive Function & Mental Performance (Tier 4)
SCOPE: Focus capacity, decision fatigue, brain health, learning/intellectual stimulation.
ARTIFACT: society/smart_goals/score_coverage_4_3.md"

# 4.4 Resilience
add_member "Resilience Evaluator" "Evaluates smart goal coverage for resilience & adaptability (Tier 4)."
add_job "dimension_evaluator_4_4" "Resilience Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.4 Resilience & Adaptability (Tier 4)
SCOPE: Routine recovery protocols, travel-proof habits, stress response diversification, graceful degradation.
ARTIFACT: society/smart_goals/score_coverage_4_4.md"

# 4.5 Identity
add_member "Identity Evaluator" "Evaluates smart goal coverage for identity & self-concept (Tier 4)."
add_job "dimension_evaluator_4_5" "Identity Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.5 Identity & Self-Concept (Tier 4)
SCOPE: Identity shift, celebrating wins, self-compassion, strengths acknowledgment.
ARTIFACT: society/smart_goals/score_coverage_4_5.md"

# 4.6 Time Mastery
add_member "Time Mastery Evaluator" "Evaluates smart goal coverage for time mastery & awareness (Tier 4)."
add_job "dimension_evaluator_4_6" "Time Mastery Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.6 Time Mastery & Awareness (Tier 4)
SCOPE: Time tracking/audit, allocation vs priorities, reducing time sinks, feedback loop.
ARTIFACT: society/smart_goals/score_coverage_4_6.md"

# 4.7 Transition & Recovery
add_member "Transition Recovery Evaluator" "Evaluates smart goal coverage for transition & recovery resilience (Tier 4)."
add_job "dimension_evaluator_4_7" "Transition Recovery Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.7 Transition & Recovery Resilience (Tier 4)
SCOPE: Post-procedure protocols, routine integrity during recovery, planning around disruptions, cascade prevention.
ARTIFACT: society/smart_goals/score_coverage_4_7.md"

# 4.8 Habit Stacking
add_member "Habit Stacking Evaluator" "Evaluates smart goal coverage for habit stacking & behavioral architecture (Tier 4)."
add_job "dimension_evaluator_4_8" "Habit Stacking Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.8 Habit Stacking & Behavioral Architecture (Tier 4)
SCOPE: Habit chain mapping, failure cascade analysis, bundle optimization, cue/reward design, minimum viable chain.
ARTIFACT: society/smart_goals/score_coverage_4_8.md"

# 4.9 Information Sovereignty
add_member "Information Sovereignty Evaluator" "Evaluates smart goal coverage for information sovereignty & life visibility (Tier 4)."
add_job "dimension_evaluator_4_9" "Information Sovereignty Evaluator" "$INSTRUCTIONS_PREFIX

DIMENSION: 4.9 Information Sovereignty & Life Visibility (Tier 4)
SCOPE: Health data pipeline, financial data pipeline, activity/time data, data quality, integration architecture, privacy.
ARTIFACT: society/smart_goals/score_coverage_4_9.md"

echo ""
echo "=== DONE ==="
echo "Counting entries..."
MEMBERS=$(curl -s "$SUPABASE_URL/rest/v1/smind_society?select=name&type=eq.extended" \
  -H "apikey: $SUPABASE_SERVICE_KEY" \
  -H "Authorization: Bearer $SUPABASE_SERVICE_KEY" -H "Prefer: count=exact" -I 2>/dev/null | grep -i content-range | grep -oP '/\K\d+')
JOBS=$(curl -s "$SUPABASE_URL/rest/v1/smind_society_extended?select=job_name" \
  -H "apikey: $SUPABASE_SERVICE_KEY" \
  -H "Authorization: Bearer $SUPABASE_SERVICE_KEY" -H "Prefer: count=exact" -I 2>/dev/null | grep -i content-range | grep -oP '/\K\d+')
echo "Extended members in smind_society: $MEMBERS"
echo "Jobs in smind_society_extended: $JOBS"
