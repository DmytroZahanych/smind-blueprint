# SMind Blueprint 🧠

A replicable blueprint for building **SMind** — a self-improving personal AI assistant — on top of [OpenClaw](https://docs.openclaw.ai).

## What is SMind?

SMind is a personal AI assistant that:

- **Learns about you** over time through conversation, building a structured user model
- **Sets and tracks goals** across all dimensions of your life
- **Schedules your days** based on your goals, constraints, and preferences
- **Self-improves** through an autonomous "society" of AI entities that evaluate and enhance data quality
- **Asks smart questions** to fill knowledge gaps, delivered at the right moment
- **Remembers everything** via persistent memory files and a Supabase database

## Architecture

SMind runs a nightly pipeline of 9 core entities (+ 7 extended) and 16 jobs:

- **Scientist** — produces quality benchmarks (schema-only, never reads your data)
- **Evaluator** — grades your data against benchmarks, opens GitHub issues
- **Workers** (UDM, LDL, SGC, Scheduler, FDGA) — address issues, improve data
- **Face** — delivers questions to you via Telegram at natural moments
- **Snapshot** — nightly database backups as GitHub PRs

## Quick Start

👉 **[Read SETUP.md](SETUP.md)** for the full installation guide.

**Prerequisites:**
- OpenClaw installed and configured
- Supabase account (free tier works)
- GitHub account with PAT
- AgentMail account
- Telegram bot (or other messaging channel)

## License

MIT
