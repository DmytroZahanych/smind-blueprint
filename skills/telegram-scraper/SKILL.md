---
name: telegram-scraper
description: >
  Scrape and cache Telegram messages from channels and groups via a local FastAPI server.
  Use when the user wants to: (1) download/export Telegram channel or group message history,
  (2) search across Telegram messages, (3) find or list Telegram dialogs/channels,
  (4) download media from Telegram messages, (5) authenticate a Telegram user session,
  or (6) adjust scraper settings. Triggers on keywords: telegram, scrape, channel history,
  telegram messages, telegram export, telegram search.
---

# Telegram Scraper API

Local FastAPI server providing authenticated access to Telegram message history, dialog search, media files, and folder management. Base URL: `http://localhost:8000`

## Server Details (This Deployment)

- **URL:** `http://localhost:8000`
- **API docs:** `http://localhost:8000/docs`
- **Container name:** `telegram-scraper`
- **Image:** `telegram-scraper-server:latest`
- **Source repo:** `/root/.openclaw/workspace/telegram-scraper-server`
- **Data volume:** `/root/.openclaw/workspace/telegram-scraper-server/data` → `/app/data`
- **Authenticated user:** <ask user about their username>

To rebuild after repo updates:
```bash
cd /root/.openclaw/workspace/telegram-scraper-server
docker stop telegram-scraper && docker rm telegram-scraper
docker build -t telegram-scraper-server .
docker run -d --name telegram-scraper --restart unless-stopped \
  -p 8000:8000 \
  -v /root/.openclaw/workspace/telegram-scraper-server/data:/app/data \
  -e TELEGRAM_API_ID=<id> \
  -e TELEGRAM_API_HASH=<hash> \
  telegram-scraper-server
```

## Security

**NEVER save or persist** the user's Telegram API ID, API Hash, or 2FA password in skill files or memory. Request credentials on-the-fly and pass them directly to commands.

## Rate Limiting (FloodWaitError)

Telegram rate-limits aggressive API usage. The server's Telethon client auto-sleeps up to **120 seconds** on `FloodWaitError`. If a `429` response is returned:

1. **Notify the user** with the wait time from the `Retry-After` header
2. Suggest reducing `chunk_size` (50–100) or lowering `telegram_batch_size` via `/api/v3/settings`

## Server Setup

### 1. Check if running

```bash
curl -s http://localhost:8000/health
# → {"status": "healthy"}
```

### 2. Launch the server

Ask the user for Telegram API credentials from https://my.telegram.org/apps.

**Docker:**

```bash
if docker ps -a --format '{{.Names}}' | grep -q '^telegram-scraper$'; then
  docker start telegram-scraper
else
  docker run -d -p 8000:8000 \
    -e TELEGRAM_API_ID=USER_PROVIDED_API_ID \
    -e TELEGRAM_API_HASH=USER_PROVIDED_API_HASH \
    -v /root/.openclaw/workspace/telegram-scraper-server/data:/app/data \
    --name telegram-scraper --restart unless-stopped \
    telegram-scraper-server
fi
```

### 3. QR Code Authentication

**Auto-detecting username:** Resolve the user's Telegram username from inbound chat metadata:

```bash
curl -s "https://api.telegram.org/bot<BOT_TOKEN>/getChat?chat_id=<CHAT_ID>" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['result']['username'])"
```

Extract `chat_id` from inbound message metadata and `botToken` from `/root/.openclaw/openclaw.json`.

**Start QR login:**

```bash
curl -s -X POST http://localhost:8000/api/v3/auth/qr \
  -H "Content-Type: application/json" \
  -d '{"username": "SESSION_NAME"}'
```

Use `{"username": "SESSION_NAME", "force": true}` to re-authenticate an existing session (otherwise returns `409`).

**QR auto-refresh loop** (do NOT wait for the user to say the QR expired):

1. POST `/api/v3/auth/qr` to get `token` + `qr_url`
2. Generate QR image: `python3 -c "import qrcode; qrcode.make('<qr_url>').save('/tmp/tg_qr.png')"`
3. Send the image to the user via the `message` tool
4. Poll `GET /api/v3/auth/qr/{token}` every ~3s
5. If status is `pending` and `qr_url` changed → regenerate + resend QR image
6. If status is `expired` → go to step 1 (new session)
7. If status is `password_required` → ask user for 2FA password, then POST to `/auth/qr/{token}/2fa`
8. If status is `success` → done

**Cancel:** `DELETE /api/v3/auth/qr/$TOKEN`

### 4. Verify authentication

```bash
curl -s -H "X-Telegram-Username: SESSION_NAME" \
  "http://localhost:8000/api/v3/search/dialogs?limit=3"
```

Sessions persist in `{data_dir}/sessions/` and survive server restarts.

---

## API Reference

All endpoints require the `X-Telegram-Username` header with the session name used during authentication.

**Note:** Use `%20` for spaces in query strings, not `+`.

### 1. Search Dialogs

`GET /api/v3/search/dialogs`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `q` | string | — | Search query on dialog title (omit for all) |
| `match` | enum | `fuzzy` | `fuzzy` (scored) or `exact` (substring) |
| `min_score` | float | `0.8` | Fuzzy score threshold (0.0–1.0) |
| `type` | enum[] | — | `user`, `group`, `supergroup`, `channel`, `bot`, `saved`, `me`. Repeat for multiple |
| `is_archived` | bool | — | Filter by archive status |
| `min_messages` | int | — | Minimum message count |
| `max_messages` | int | — | Maximum message count |
| `min_participants` | int | — | Minimum participant count |
| `max_participants` | int | — | Maximum participant count |
| `last_message_after` | date | — | `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS` |
| `last_message_before` | date | — | `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS` |
| `created_after` | date | — | `YYYY-MM-DD` (channels/groups only) |
| `created_before` | date | — | `YYYY-MM-DD` (channels/groups only) |
| `is_creator` | bool | — | Only dialogs you created |
| `has_username` | bool | — | Only dialogs with/without public @username |
| `is_verified` | bool | — | Only verified entities |
| `sort` | enum | `last_message` | `last_message`, `messages`, `title`, `participants`, `unread` |
| `order` | enum | `desc` | `desc` or `asc` |
| `limit` | int | `50` | Page size (1–500) |
| `offset` | int | `0` | Skip N results for pagination |

**Note:** No `folder` parameter — use `/folders?include_dialogs=true` to get dialog lists per folder, then filter by dialog IDs.

### 2. List Folders

`GET /api/v3/folders`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `include_dialogs` | bool | `false` | If `true`, each folder includes a `dialogs` array (id + title) for explicitly included peers |

Returns only **custom folders** (built-in All Chats/Archive are excluded).

```bash
# Folders only
curl -s -H "X-Telegram-Username: $USERNAME" \
  "http://localhost:8000/api/v3/folders"

# Folders with dialog lists
curl -s -H "X-Telegram-Username: $USERNAME" \
  "http://localhost:8000/api/v3/folders?include_dialogs=true"
```

**Response (with include_dialogs=true):**
```json
[
  {"id": 2, "title": "Work", "dialogs": [{"id": -1001234567890, "title": "Crypto News"}]},
  {"id": 3, "title": "Personal", "dialogs": [...]}
]
```

### 3. Search Messages

Search using Telegram's native search API. **No pre-caching required.**

#### Within a specific dialog

`GET /api/v3/search/messages/{dialog_id}`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `q` | string | *required* | Search query |
| `start_date` | string | — | Upper bound — messages before this date (`YYYY-MM-DD`) |
| `end_date` | string | — | Lower bound — messages after this date (`YYYY-MM-DD`) |
| `from_user` | int | — | Only messages sent by this user ID |
| `limit` | int | `50` | Maximum results (1–500) |

#### Across all dialogs (global search)

`GET /api/v3/search/messages`

Same params minus `from_user`.

### 4. Message History (SSE Streaming)

`GET /api/v3/history/{dialog_id}`

Always use `curl -N` to enable streaming.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `start_date` | string | chat beginning | `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS` |
| `end_date` | string | now | `YYYY-MM-DD` or `YYYY-MM-DD HH:MM:SS` |
| `chunk_size` | int | `100` | Messages per SSE chunk (must be > 0) |
| `force_refresh` | bool | `false` | Bypass cache and re-download from Telegram |
| `reverse` | bool | `true` | If `true`, stream oldest-first. If `false`, newest-first |

Messages are cached in SQLite per dialog. First request downloads from Telegram; subsequent requests serve from cache.

**Message object fields:** `message_id`, `date` (UTC, `YYYY-MM-DD HH:MM:SS`), `edit_date`, `sender_id`, `first_name`, `last_name`, `username`, `message`, `reply_to`, `post_author`, `is_forwarded` (0/1), `forwarded_from_channel_id`, `media_type`, `media_uuid`, `media_original_filename`, `media_size`.

**`media_type` values:** `photos`, `videos`, `voice_messages`, `video_messages`, `stickers`, `gifs`, `files` (or `null` if no media). These are human-readable category names, not Telegram class names.

### 5. Download Media

`GET /api/v3/files/{file_uuid}`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `metadata_only` | bool | `false` | Return JSON metadata instead of file content |

**Preferred method — direct file access (when Docker volume is mounted):**

Instead of downloading via HTTP, use `metadata_only=true` to get the container-internal file path, then map it to the host path using the volume mount:

```bash
# 1. Get metadata (returns container-internal path like /app/data/dialogs/.../media/file.jpg)
curl -s -H "X-Telegram-Username: $USERNAME" \
  "http://localhost:8000/api/v3/files/$FILE_UUID?metadata_only=true"

# 2. Map container path → host path by replacing the mount prefix
# Container mount: /app/data  →  Host: <your-volume-path>
# Example for this deployment:
#   /app/data/...  →  /root/.openclaw/workspace/telegram-scraper-server/data/...
HOST_PATH="${CONTAINER_PATH/\/app\/data/\/root\/.openclaw\/workspace\/telegram-scraper-server\/data}"

# 3. Access the file directly on the host filesystem
cp "$HOST_PATH" ./my_file.jpg
```

This is faster and avoids HTTP overhead. **Only works when the data directory is volume-mounted.** If the container runs without a mounted volume (data lives only inside the container), fall back to HTTP download:

```bash
curl -s -H "X-Telegram-Username: $USERNAME" \
  "http://localhost:8000/api/v3/files/$FILE_UUID" -o photo.jpg
```

### 6. Settings

`GET /api/v3/settings` — read current settings
`PATCH /api/v3/settings` — update (partial)

| Setting | Default | Description |
|---------|---------|-------------|
| `download_media` | `true` | Download media during history scraping |
| `max_media_size_mb` | `20` | Max media size in MB. `0`/`null` = no limit |
| `telegram_batch_size` | `100` | Batch size for Telegram API downloads |
| `repair_media` | `true` | Re-download previously skipped media |
| `download_file_types` | object | Per-type toggles: `photos`, `videos`, `voice_messages`, `video_messages`, `stickers`, `gifs`, `files`. All `true` by default. |

---

## Error Responses

| Code | Meaning |
|------|---------|
| `400` | Invalid parameters |
| `401` | Missing header or unauthenticated session |
| `404` | QR session / media / folder not found |
| `409` | Session exists (use `force: true`) or wrong 2FA state |
| `422` | No fields provided for settings update |
| `429` | Telegram rate limit — check `Retry-After` header |
| `500` | Internal server error |
| `502` | Failed to connect to Telegram |

---

## Data Directory Layout

```
{data_dir}/
├── sessions/              Telegram session files
├── dialogs/{dialog_id}/
│   ├── {dialog_id}.db    SQLite message cache
│   └── media/            Downloaded media files
└── settings.yaml          Runtime settings
```

## Quick Tips

1. **Always use `-N` with curl** for SSE endpoints (`/history/`)
2. **Use `chunk_size=50`** for large histories to reduce rate limit risk
3. **Media capped at 20MB by default** — increase via settings if needed
4. **Use `force_refresh=true` sparingly** — prefer cached data
5. **Fuzzy search**: `min_score=0.6` for broad, `0.8`+ for precise
6. **Check logs**: `docker logs telegram-scraper`
7. **API docs**: http://localhost:8000/docs
