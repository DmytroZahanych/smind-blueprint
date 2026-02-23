# SMind Blueprint — Setup Guide

This guide walks you through turning a clean OpenClaw installation into a fully operational SMind personal AI assistant.

**What you'll get:**
- A self-improving AI assistant with persistent memory
- A "society" of specialized AI entities that evaluate and improve your data
- Automated scheduling, goal tracking, and user profiling
- A dashboard to visualize the society's activity

**Time required:** ~1-2 hours

---

## Prerequisites

- ✅ OpenClaw installed and running ([docs.openclaw.ai](https://docs.openclaw.ai))
- ✅ A messaging channel configured (Telegram recommended)
- ✅ Basic familiarity with terminal/CLI

---

## Step 1: Gather API Keys & Accounts

You'll need the following. Get them all before proceeding.

### Required

| Service | What You Need | Where to Get It |
|---------|--------------|-----------------|
| **Supabase** | Project URL + Service Role Key | [supabase.com](https://supabase.com) — create a free project |
| **GitHub** | Personal Access Token (PAT) with `repo` scope | [github.com/settings/tokens](https://github.com/settings/tokens) |
| **AgentMail** | API Key | [agentmail.to](https://agentmail.to) — sign up, get key |

### Optional

| Service | What You Need | Why |
|---------|--------------|-----|
| **Google OAuth** | OAuth credentials (client_id, client_secret) | Read-only calendar/drive access |
| **Telegram API** | api_id + api_hash | For Telegram scraper skill |

---

## Step 2: Set Up Supabase

### 2.1 Create Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Note your **Project URL** and **Service Role Key** (Settings → API)

### 2.2 Run Migration

Open the Supabase SQL Editor and paste the contents of `supabase/migration.sql`. Run it.

This creates 12 tables + 1 RPC function:
- `user_model_profile_as_items` — user profile facts
- `user_model_scheduling_constraints_and_preferences` — calendar/scheduling data
- `user_data_history` — activity history
- `smind_schedule_today` — today's schedule
- `smind_schedule_days` — rolling multi-day schedule
- `smind_schedule_outcomes` — schedule outcome tracking
- `smind_society` — society entity registry
- `smind_society_core_jobs` — job definitions with instructions
- `smind_smart_goals` — goals
- `smind_life_dimensions` — discovered life dimensions
- `smind_hos_life_dimensions` — higher-order structure dimensions
- `smind_data_gap_questions` — questions for the user
- `exec_sql` — RPC function for arbitrary SQL queries

### 2.3 Bootstrap Society

After migration, run `society/bootstrap.sql` in the SQL Editor. This populates:
- 9 core entities + 7 extended Life Dimension Agents
- 16 core jobs with full instructions

### 2.4 Configure Environment

Add these to your OpenClaw environment (or `.env` file):

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=eyJ...your-service-role-key
```

---

## Step 3: Set Up GitHub

### 3.1 Create Society Repo

Create a repo for society coordination (issues, benchmarks, snapshots):

```bash
gh repo create your-username/smind-society --public
```

### 3.2 Store GitHub PAT

```bash
# Store in git credentials
echo "https://x-access-token:YOUR_PAT@github.com" >> /root/.git-credentials
git config --global credential.helper store
```

### 3.3 Install gh CLI

If not already installed:

```bash
# See https://cli.github.com/
gh auth login
```

---

## Step 4: Set Up AgentMail

1. Sign up at [agentmail.to](https://agentmail.to)
2. Create your main inbox (e.g., `youragent@agentmail.to`)
3. Add the API key to your environment:

```bash
AGENTMAIL_API_KEY=your-api-key
```

---

## Step 5: Copy Workspace Files

Copy the template files into your OpenClaw workspace:

```bash
WORKSPACE=~/.openclaw/workspace

# Copy all templates
cp workspace-templates/AGENTS.md $WORKSPACE/
cp workspace-templates/SOUL.md $WORKSPACE/
cp workspace-templates/IDENTITY.md $WORKSPACE/
cp workspace-templates/USER.md $WORKSPACE/
cp workspace-templates/BOOT.md $WORKSPACE/
cp workspace-templates/HEARTBEAT.md $WORKSPACE/
cp workspace-templates/TOOLS.md $WORKSPACE/
cp workspace-templates/SCHEMA.md $WORKSPACE/
cp workspace-templates/MEMORY.md $WORKSPACE/

# Create memory directory
mkdir -p $WORKSPACE/memory
```

### 5.1 Customize

Edit these files and replace all `<PLACEHOLDER>` values:

- **`USER.md`** — your name, Telegram handle, timezone, quiet hours
- **`IDENTITY.md`** — your assistant's name and personality
- **`TOOLS.md`** — your GitHub username, AgentMail inboxes
- **`HEARTBEAT.md`** — your Telegram ID (for message delivery)
- **`AGENTS.md`** — your name and Telegram ID in protocols

Search for `<YOUR_` across all files to find all placeholders.

---

## Step 6: Install Skills

```bash
cd ~/.openclaw/workspace

# Supabase skill (required)
clawhub install supabase

# AgentMail skill (required)
clawhub install agentmail

# Telegram scraper (optional)
clawhub install telegram-scraper
```

See `skills/README.md` for detailed setup per skill.

---

## Step 7: Copy Society Artifacts

```bash
# Copy scientist benchmarks to workspace
cp -r society/scientist ~/.openclaw/workspace/society/

# Clone your society repo
cd ~/.openclaw/workspace
git clone https://github.com/your-username/smind-society.git
```

Push the scientist benchmarks to the society repo:

```bash
cd smind-society
cp -r ../society/scientist .
git add -A && git commit -m "Initial scientist benchmarks" && git push
```

---

## Step 8: Cron Jobs (Do NOT bulk-create)

The society pipeline is documented in `cron/README.md` but **do not create all jobs at once**. The pipeline is still being tested and refined.

**Recommended approach:**
1. Start with **no cron jobs** — run society jobs manually to understand what they do
2. Enable **Snapshot** first (low risk, just backs up data)
3. Gradually enable **Scientist** jobs once you have data in your tables
4. Add **Evaluator** jobs after Scientist benchmarks exist
5. Add **Worker** jobs last, after you've verified Evaluator issues make sense

To run a job manually, ask your SMind:
```
Run the scientist_udm_benchmark job — fetch instructions from smind_society_core_jobs and execute them
```

When ready to automate a specific job, create its cron entry (see `cron/README.md` for schedule and payload format).

---

## Step 9: Dashboard (Optional)

The dashboard visualizes your society's activity.

### 9.1 Copy Dashboard

```bash
cp -r dashboard/ ~/.openclaw/workspace/dashboard/
```

### 9.2 Generate Viewmodel

The dashboard needs a `viewmodel.json` file generated from your Supabase data. See `dashboard/GENERATE.md` for the schema and generation instructions.

Ask your SMind to generate it:

```
Generate viewmodel.json for the dashboard following GENERATE.md
```

### 9.3 Run Dashboard

```bash
cd ~/.openclaw/workspace/dashboard
python3 server.py
# Opens on http://localhost:8000
```

---

## Step 10: First Boot

1. Restart OpenClaw: `openclaw gateway restart`
2. Your SMind should read BOOT.md, verify Supabase access, and send a startup ping
3. Verify it can:
   - Query Supabase tables (ask it to list tables)
   - Access GitHub (ask it to list issues in smind-society)
   - Send messages via your configured channel

---

## Customization Guide

### Adding New Protocols

Edit `AGENTS.md` → Protocols section. Each protocol needs:
- **Trigger** — when it activates
- **Protocol** — what to do

### Adding Society Entities

1. Insert into `smind_society` table
2. Create job(s) in `smind_society_core_jobs` with instructions
3. Set up cron job(s) to run them

### Tuning Heartbeat Behavior

Edit `HEARTBEAT.md` to change:
- What gets checked on heartbeats
- Timing heuristics for asking questions
- Quiet hours

### Adding Integrations

Create new skills in `~/.openclaw/workspace/skills/` or install from ClawHub. Health trackers, calendars, email providers — anything with an API can be integrated.

---

## Architecture Overview

```
┌─────────────────────────────────────────────┐
│                  Pipeline                     │
│                                               │
│  Scientist ──→ Evaluator ──→ Workers          │
│  (benchmarks)   (GitHub     (fix issues)      │
│                  issues)                       │
│                                               │
│  Workers: UDM, LDL, SGC, Scheduler, FDGA     │
│                                               │
│  Face ──→ User (via Telegram heartbeat)       │
│  Snapshot ──→ GitHub PRs (nightly backup)     │
└─────────────────────────────────────────────┘

Data flow:
  User conversation → on_message_ingest → Supabase user model
  Scientist → benchmarks (schema-only, no data content)
  Evaluator → grades data vs benchmarks → GitHub issues
  Workers → read issues → fix data → comment on issues
  Evaluator → verify fixes → close issues
  Face → deliver questions → user answers → ingest
```

---

## Troubleshooting

### Supabase queries return empty
Use REST API directly, not `exec_sql` RPC:
```bash
curl -s "$SUPABASE_URL/rest/v1/TABLE?select=*" \
  -H "apikey: $SUPABASE_SERVICE_KEY" \
  -H "Authorization: Bearer $SUPABASE_SERVICE_KEY"
```

### Cron jobs not running
Check `openclaw status` and verify jobs are enabled. Society jobs need the `smind_society_core_jobs` table populated with instructions.

### Dashboard shows no data
Generate `viewmodel.json` first — see `dashboard/GENERATE.md`.

---

## Files in This Repo

```
smind-blueprint/
├── SETUP.md                    ← You are here
├── README.md                   ← Project overview
├── workspace-templates/        ← Template workspace files
│   ├── AGENTS.md
│   ├── BOOT.md
│   ├── HEARTBEAT.md
│   ├── IDENTITY.md
│   ├── MEMORY.md
│   ├── SCHEMA.md
│   ├── SOUL.md
│   ├── TOOLS.md
│   └── USER.md
├── supabase/
│   └── migration.sql           ← Database schema
├── society/
│   ├── bootstrap.sql           ← Entity & job data
│   └── scientist/              ← Benchmark artifacts
├── cron/
│   └── README.md               ← Cron job schedule & setup
├── skills/
│   └── README.md               ← Skill installation guide
├── scripts/
│   ├── populate_extended_society.sh  ← Populate extended entities via REST
│   └── regen_viewmodel_dimensions.py ← Regenerate dashboard viewmodel
└── dashboard/
    ├── index.html              ← FUI dashboard
    ├── server.py               ← Simple HTTP server
    ├── GENERATE.md             ← Viewmodel generation instructions
    └── README.md               ← Dashboard docs
```
