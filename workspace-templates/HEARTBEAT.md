# HEARTBEAT.md

## Face — Question Delivery Subroutine

Face is responsible for getting answers to data gap questions from `smind_data_gap_questions`.

### On Each Heartbeat

1. **Check `smind_data_gap_questions`** — are there pending questions?

   ⚠️ **USE REST API, NOT supabase.sh query** — the `supabase.sh query` RPC silently returns empty results. Always use:
   ```
   curl -s "$SUPABASE_URL/rest/v1/smind_data_gap_questions?select=*" \
     -H "apikey: $SUPABASE_SERVICE_KEY" \
     -H "Authorization: Bearer $SUPABASE_SERVICE_KEY"
   ```

2. **Validate each question** — before considering a question, verify:
   
   a) **Cross-check user model**: Does `user_model_profile_as_items` already contain the information this question seeks? If yes → delete the question (it's been answered through conversation).
   
   b) **Evaluate trigger condition**: Don't just read the text — actually query to verify:
      - If trigger says "after X is answered" → check if X is gone from `smind_data_gap_questions`
      - If trigger says "after baseline established" → check if that data exists in user model
      - If trigger says "BLOCKED" → skip this question
      - If trigger says "week 3+" → check actual elapsed time
   
   c) **Delete stale questions**: If validation reveals the question is answered or obsolete, delete it from `smind_data_gap_questions` (and close GitHub issue if exists) before moving on.

3. **Assess timing** — is now a good time to ask?
   - Recent conversation activity? (engaged user = good time)
   - Time of day? (respect quiet hours: 22:00-08:00 Europe/Lisbon)
   - Did user just answer a question? (engagement burst = ask follow-up)
   - Has it been a while since last question? (don't let questions pile up)
   - User seemed annoyed or busy last interaction? (back off)

4. **Pick question(s)** — if timing is right:
   - Prioritize by `priority` field (high > medium > low)
   - Consider `trigger_condition` for context-dependent questions
   - Usually ask ONE question at a time (respect user attention)
   - Exception: engagement burst → can ask follow-up immediately

5. **Present question** — minimize user effort:
   - **Inline buttons preferred** — if question has clear options, use buttons
   - Format: question text + button grid with callback_data = `q:<key>:<option>`
   - Free-text fallback — if question needs open response, just ask naturally
   - Keep it conversational, not robotic

### Question Presentation Format

⚠️ **USE THE MESSAGE TOOL WITH BUTTONS** — do NOT send options as plain text!

For button-ready questions, use `message` tool with `buttons` parameter:
```
action: send
channel: telegram
target: <YOUR_TELEGRAM_ID>
message: "<question_text>"
buttons: [[{"text": "Option 1", "callback_data": "q:<key>:1"}], [{"text": "Option 2", "callback_data": "q:<key>:2"}]]
```

- Each `[{...}]` is a row; put one button per row for vertical layout
- `callback_data` format: `q:<question_key>:<option_number>`
- This format lets `on_face_question_response` protocol identify Face answers

**DO NOT** send a separate message with numbered options as text. That defeats the purpose.

### Timing Heuristics

- **Ask** when: user active in last hour, daytime, just answered something, conversation lull
- **Wait** when: late night, user stressed/busy, just asked a question with no response, no activity in 4+ hours
- **Never** spam: max 2-3 questions per day unless user is clearly engaged and answering

### Timing Examples (calibration)

**✅ GOOD time to ask:**
- User just finished answering a question → engagement burst, ask follow-up
- User just did admin/config work with you → they're engaged, pivot to a question
- User is actively chatting, even about unrelated topics → they're present
- Daytime + any recent activity in last 10 minutes → fair game
- User said "not sure yet" to a question days ago → retry is fine

**❌ NOT a good time:**
- Late night (22:00-08:00 Europe/Lisbon) unless user initiated
- User explicitly said they're busy/stressed
- User ignored last 2+ questions in a row → back off
- No activity in 4+ hours and you're about to cold-ping

**🔑 Key insight:** "Just finished a conversation" is NOT a reason to hold back. If the user is engaged and responsive, that's the BEST time to ask. Don't be overly conservative — questions pile up if you keep waiting for "perfect" moments.

### Heartbeat Report

**After each heartbeat, send a brief Telegram report** summarizing what happened:

```
action: send
channel: telegram
target: <YOUR_TELEGRAM_ID>
message: "<heartbeat report>"
```

Report format:
- What was checked (questions, timing assessment)
- What action was taken (asked question / HEARTBEAT_OK / other)
- Why (brief reasoning)
- 📊 Context usage (from session_status — always include)

Keep it short — 2-4 lines max. This helps <YOUR_NAME> observe behavior and tune the system.
