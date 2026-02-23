# Required Skills

Install these skills for full SMind functionality.

## 1. Supabase

Database operations, vector search, and storage.

```bash
# Install via ClawHub (if available)
clawhub install supabase

# Or manually: copy the supabase skill folder to your workspace skills/
```

**Required env vars:**
- `SUPABASE_URL` — your Supabase project URL
- `SUPABASE_SERVICE_KEY` — service role key (not anon key)

## 2. AgentMail

API-first email for AI agents.

```bash
clawhub install agentmail
```

**Required env vars:**
- `AGENTMAIL_API_KEY` — from agentmail.to

**Setup:**
1. Sign up at https://agentmail.to
2. Create your main inbox (e.g., `youragent@agentmail.to`)
3. Create additional inboxes for society entities as needed

## 3. Telegram Scraper (Optional)

Scrape Telegram channels/groups. Only needed if you want to ingest Telegram history.

```bash
clawhub install telegram-scraper
```

**Required:** Telegram API credentials (api_id, api_hash from my.telegram.org)

## General Skill Installation

Skills live in `~/.openclaw/workspace/skills/` or can be installed via ClawHub:

```bash
# Search for skills
clawhub search <query>

# Install a skill
clawhub install <skill-name>
```
