#!/usr/bin/env python3
"""Regenerate viewmodel.json lifeDimensions + hosDimensions from smind_society_extended."""
import json, re, os

VIEWMODEL = '/root/.openclaw/workspace/dashboard/viewmodel.json'
SUPABASE_URL = os.environ['SUPABASE_URL']
SUPABASE_KEY = os.environ['SUPABASE_SERVICE_KEY']

def supabase_get(table, params=''):
    import urllib.request
    url = f"{SUPABASE_URL}/rest/v1/{table}?{params}"
    req = urllib.request.Request(url, headers={
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}'
    })
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())

# Goal -> primary dimension mapping (from coverage benchmark)
GOAL_DIM_MAP = {
    'nutrition-eliminate-daily-sweets': '1.1',
    'nutrition-intermittent-fasting-6h': '1.1',
    'movement-daily-walking-30min': '1.2',
    'movement-break-sedentary-blocks': '1.2',
    'sleep-schedule-consistency': '1.3',
    'health-sleep-apnea-screening': '1.3',
    'routine-evening-winddown': '1.3',  # secondary to 1.3, primary 1.5
    'health-vitamin-d-supplementation': '1.4',
    'health-folic-acid-supplementation': '1.4',
    'routine-morning-anchor': '1.5',
    'health-cholesterol-reduction': '2.1',
    'weight-target-70kg': '2.2',
    'health-followup-blood-work': '2.3',
    'health-postsurgery-followup': '2.3',
    'immigration-aima-march-2026': '2.4',
    'mental-health-stress-awareness': '2.5',
    'pet-welfare-parrot-health': '2.6',
    'longevity-biomarker-tracking': '3.1',
    'longevity-aging-slowdown-protocol': '3.2',
    'career-professional-clarity': '3.3',
    'finance-budget-tracking': '3.4',
    'relationship-partner-quality-time': '3.5',
    'relationship-family-contact': '3.5',
    'resilience-routine-recovery-protocol': '4.4',
    'meta-time-mastery': '4.6',
}

# Secondary mappings (goal touches these dimensions too)
GOAL_SECONDARY = {
    'nutrition-eliminate-daily-sweets': ['2.1', '2.2'],
    'movement-daily-walking-30min': ['2.1', '2.2'],
    'routine-evening-winddown': ['1.5'],
    'health-sleep-apnea-screening': ['2.3'],
    'health-cholesterol-reduction': ['3.1'],
    'weight-target-70kg': ['2.1'],
    'mental-health-stress-awareness': ['1.1'],
    'longevity-biomarker-tracking': ['3.2'],
    'resilience-routine-recovery-protocol': ['4.4'],  # tier 4, will be excluded
    'movement-break-sedentary-blocks': ['4.3'],  # tier 4
    'career-professional-clarity': ['3.4'],
    'relationship-partner-quality-time': ['2.5'],
    'health-postsurgery-followup': ['4.7'],  # tier 4
}

# Build dim -> goals mapping
dim_goals = {}
for goal, dim in GOAL_DIM_MAP.items():
    dim_goals.setdefault(dim, []).append(goal)

# Subdimension coverage: which subdimension label is covered by which goal
# Based on coverage benchmark analysis
SUB_COVERED = {
    '1.1': {'Sugar/Sweets Elimination': True, 'Intermittent Fasting Restoration': True,
             'Lactose Avoidance': False, 'Overall Caloric Quality': False,
             'Hydration Habits': False, 'Kitchen Environment Design': False,
             'Meal Planning Within Fasting Window': False, 'Food Source Optimization': False},
    '1.2': {'Daily Walking Habit': True, 'Breaking Sedentary Blocks': True,
             'Strength/Resistance Training': False, 'Step Tracking Feedback Loop': False},
    '1.3': {'Sleep Schedule Consistency': True, 'Pre-Sleep Wind-Down Routine': True,
             'Sleep Apnea Investigation': True, 'Sleep Environment Optimization': False,
             'Objective Sleep Tracking': False},
    '1.4': {'Vitamin D Daily': True, 'Folic Acid Daily': True,
             'Cicaplast Wound Care': True, 'Future Reassessment': False},
    '1.5': {'Morning Anchor': True, 'Work Block Structure': False,
             'Evening Wind-Down': True, 'Transition Rituals': False,
             'Monday Sync Accommodation': False},
    '2.1': {'Lipid Panel Follow-Up': True, 'Diet-Based Cholesterol Reduction': True,
             'Exercise-Based Cholesterol Reduction': True, 'Medication Decision Point': False},
    '2.2': {'Caloric Deficit': True, 'Weight Tracking/Accountability': True},
    '2.3': {'Dental Health': False, 'Allergy Management': False,
             'Post-Surgery Follow-Up': True, 'Follow-Up Blood Work': True,
             'Chronic Issues Investigation': False, 'Massage Sessions': False,
             'Regular Check-Up Cadence': False},
    '2.4': {'AIMA Appointment Preparation': True, "Nastya's Article 89.2 Process": False},
    '2.5': {'Stress Coping Alternatives': True, 'Social Battery Management': False,
             'Trauma Processing': False, 'Turbulence Fear Management': False},
    '2.6': {'Mating Management': False, 'Veterinary Check-Up Cadence': False,
             'Enrichment & Socialization': False, 'Travel Care Arrangements': False},
    '3.1': {'Biomarker Tracking System': True, 'Risk Catalog': False,
             'Automated Health Data Ingestion': False, 'Emergency Preparedness': False},
    '3.2': {'Evidence-Based Interventions': True, 'Metabolic Age Tracking': False},
    '3.3': {'Time Allocation Neo vs SMind': True, 'Career Risk Management': False,
             'Game Plan Execution': False},
    '3.4': {'Budget Management': True, 'Tax Compliance': False, 'Bank Data Integration': False},
    '3.5': {'Quality Time with Nastya': True, 'Family Connections': True,
             'Social Circle Maintenance': False},
}

# Load extended society for labels
extended = supabase_get('smind_society_extended', 'select=job_name,member,instructions')

dims = {}
for row in extended:
    instr = row['instructions']
    m = re.search(r'DIMENSION:\s*(\d+\.\d+(?:\.\d+)?)\s', instr)
    if not m:
        continue
    dim_id = m.group(1)
    tier_m = re.search(r'Tier\s*(\d+)', instr)
    tier = int(tier_m.group(1)) if tier_m else None
    parent_m = re.search(r'subdimension of (\d+\.\d+)', instr)
    parent = parent_m.group(1) if parent_m else None
    label = row['member'].replace(' Evaluator', '').strip()
    
    dims[dim_id] = {
        'id': dim_id,
        'label': label,
        'tier': tier,
        'parent': parent,
    }

# Build new lifeDimensions - Tiers 1-3 only
tiers_data = {1: [], 2: [], 3: []}
top_dims = {k: v for k, v in dims.items() if v['parent'] is None and v['tier'] in (1, 2, 3)}

for dim_id in sorted(top_dims.keys()):
    d = top_dims[dim_id]
    sub_dims = sorted([v for v in dims.values() if v['parent'] == dim_id], key=lambda x: x['id'])
    goals = dim_goals.get(dim_id, [])
    
    # Determine status from coverage benchmark
    sub_coverage = SUB_COVERED.get(dim_id, {})
    if not goals:
        status = 'uncovered'
    elif sub_coverage:
        covered_count = sum(1 for v in sub_coverage.values() if v)
        total_count = len(sub_coverage)
        if covered_count == total_count:
            status = 'covered'
        elif covered_count > 0:
            status = 'partial'
        else:
            status = 'uncovered'
    else:
        status = 'covered' if goals else 'uncovered'
    
    # Build subdimension list
    sub_list = []
    for sd in sub_dims:
        sd_label = sd['label']
        # Match against SUB_COVERED keys
        covered = False
        for k, v in sub_coverage.items():
            if k.lower() in sd_label.lower() or sd_label.lower() in k.lower():
                covered = v
                break
        sub_list.append({'name': sd_label, 'covered': covered})
    
    dim_entry = {
        'id': dim_id,
        'name': d['label'],
        'status': status,
        'goalCount': len(goals),
        'goals': goals,
        'subDimensions': sub_list
    }
    tiers_data[d['tier']].append(dim_entry)

new_life_dims = {
    'tiers': [
        {'tier': 1, 'label': 'Immediate', 'dimensions': tiers_data[1]},
        {'tier': 2, 'label': 'Medium-Term', 'dimensions': tiers_data[2]},
        {'tier': 3, 'label': 'Long-Term', 'dimensions': tiers_data[3]},
    ]
}

# Update hosDimensions - remove Tier 4 refs
with open(VIEWMODEL) as f:
    vm = json.load(f)

old_hos = vm.get('hosDimensions', {})
tier4_ids = {d['id'] for d in dims.values() if d['tier'] == 4 and d['parent'] is None}

if old_hos:
    for cat in old_hos.get('categories', []):
        cat['dimensions'] = [d for d in cat.get('dimensions', []) if d not in tier4_ids]
    unmapped = old_hos.get('unmapped', {})
    if 'dimensions' in unmapped:
        unmapped['dimensions'] = [d for d in unmapped['dimensions'] if d not in tier4_ids]

vm['lifeDimensions'] = new_life_dims
vm['hosDimensions'] = old_hos

with open(VIEWMODEL, 'w') as f:
    json.dump(vm, f, indent=2)

# Summary
total_dims = sum(len(t['dimensions']) for t in new_life_dims['tiers'])
total_subs = sum(len(d['subDimensions']) for t in new_life_dims['tiers'] for d in t['dimensions'])
print(f"Regenerated lifeDimensions: {total_dims} dimensions, {total_subs} subdimensions")
print(f"Removed Tier 4 IDs: {sorted(tier4_ids)}")
print(f"Tiers: T1={len(tiers_data[1])}, T2={len(tiers_data[2])}, T3={len(tiers_data[3])}")
for t in new_life_dims['tiers']:
    print(f"\nTier {t['tier']} ({t['label']}):")
    for d in t['dimensions']:
        print(f"  {d['id']} {d['name']}: {d['status']} ({d['goalCount']} goals, {len(d['subDimensions'])} subs)")
