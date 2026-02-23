# TOOLS.md - Local Notes

## GitHub
- User: <YOUR_GITHUB_USERNAME>
- **Token location:** `/root/.git-credentials` (PAT stored via git credential store). Use `export GH_TOKEN=$(grep github.com /root/.git-credentials | sed 's/.*x-access-token:\(.*\)@github.com/\1/')` before `gh` commands.
- Repos:
  - `smind-society` — agent society issue coordination repo

## Supabase
- Tables: smind_schedule_*, smind_smart_goals, smind_data_gap_questions, smind_society, smind_society_core_jobs, user_model_*, user_data_history
- Has `exec_sql` RPC — parameter name is `query` (not `sql`!)
- ⚠️ **Both `supabase.sh query` and `exec_sql` RPC are unreliable** — often return `{"success": true}` with no data. Use REST API directly via curl for reliable reads.

## AgentMail
- **API base:** `https://api.agentmail.to/v0` (not v1!)
- Inboxes:
  - `<YOUR_PREFIX>@agentmail.to` — main
  - Create additional inboxes as needed for society entities

---

*Add more as needed.*
