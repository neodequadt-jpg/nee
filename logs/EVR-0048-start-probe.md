# EVR-0048 — /start Probe: Invisible or Unresponsive

**Date:** 2026-11-08  
**Task:** READ-ONLY diagnostic — why `/start` may be invisible/unresponsive for @bet_analyzer_anrhytm_bot

---

## Step 1 — grep /start dispatch in tg_bot.py

```
2181:    if command in ("/start", "/help"):
2407:    if cmd in ("/start", "/help", "/subscribe"):
2447:    if command in ("/start", "/help"):
```

- Line 2181: `dispatch()` returns `WELCOME_TEXT` for `/start` and `/help`
- Line 2407: `handle()` whitelist — `/start` allowed for all users (no admin-only gate)
- Line 2447: `handle()` calls `send_message(chat_id, get_welcome_text(chat_id), reply_markup=get_main_keyboard(chat_id))`

**→ /start IS in dispatch. YES.**

---

## Step 2 — get_welcome_text(0) output

```
710 '<b>🧠 Bet Edge bot</b>\nPipeline: Fonbet + Smarkets + manual → consensus → EV → value bets.\n\n<b>Команд'
```

**→ get_welcome_text(0) is non-empty: 710 chars. YES.**

---

## Step 3 — journalctl for bot service

```
ноя 08 20:16:24 jailLMDE systemd[1541]: Started bet-edge-bot.service - Bet Edge Telegram bot.
ноя 08 20:27:08 jailLMDE bet-edge-bot.sh[2034]: [tg_bot] handle update failed: 400 Client Error: Bad Request for url: https://telegram-api-proxy.neodequadt.workers.dev/bot<REDACTED>/sendMessage
```

- Service started and active (build_pipeline logs every ~15 min)
- **One 400 error on sendMessage** via Cloudflare Worker proxy at `telegram-api-proxy.neodequadt.workers.dev`
- No getUpdates/polling errors; no 401 (token valid)

**→ Bot IS polling. YES.**  
**→ BUT: 400 Bad Request on sendMessage — some responses fail to deliver.**

---

## Step 4 — getMe

```json
{"ok":true,"result":{"id":8165315037,"is_bot":true,"first_name":"Bet Edge","username":"bet_analyzer_anrhytm_bot",...}}
```

**→ Token valid, bot exists. YES.**

---

## Step 5 — getWebhookInfo

```json
{"ok":true,"result":{"url":"","has_custom_certificate":false,"pending_update_count":0}}
```

**→ Webhook NOT set (url=""). No conflict with polling. OK.**

---

## Step 6 — getMyCommands

```json
{
  "ok": true,
  "result": [
    {"command": "value",    "description": "Value bets с EV"},
    {"command": "signals",  "description": "Топ-5 сигналов + Kelly"},
    {"command": "express",  "description": "AI-экспресс"},
    {"command": "live",     "description": "Ближайшие матчи"},
    {"command": "bonuses",  "description": "Фрибеты и бонусы БК"},
    {"command": "plan",     "description": "Matched betting план"},
    {"command": "stats",    "description": "ROI за 7 дней"},
    {"command": "status",   "description": "Статус бота"},
    {"command": "subscribe","description": "Premium подписка"}
  ]
}
```

**→ /start is NOT in getMyCommands. NO.**  
**→ /help is NOT in getMyCommands. NO.**

---

## Diagnosis

| Check | Result |
|-------|--------|
| /start in dispatch? | ✅ YES (lines 2181, 2447) |
| get_welcome_text non-empty? | ✅ YES (710 chars) |
| Bot polling? | ✅ YES (systemd active) |
| Webhook set? | ✅ NO (no conflict) |
| /start in getMyCommands? | ❌ **NO** — not registered in bot menu |
| sendMessage 400 errors? | ⚠️ YES — proxy returning 400 Bad Request |

### Root cause

**`/start` is missing from the Telegram Bot Menu commands** (`setMyCommands`). Users who open the bot see a command menu with 9 entries but **no `/start` and no `/help`**. This makes `/start` **invisible** — users don't know to type it, and it doesn't appear in autocomplete.

Additionally, the 400 error on `sendMessage` (via the `telegram-api-proxy.neodequadt.workers.dev` proxy) means that **even if a user types `/start` manually**, the response *may* fail with a 400 Bad Request. This would make the bot appear **unresponsive** for that interaction.

---

## VERDICT

**VERDICT: menu_missing**

**Fix:** Add `/start` and `/help` to the `setMyCommands` call (or the commands list in `main()`) so they appear in the Telegram bot menu. Also investigate the 400 Bad Request from the Cloudflare Worker proxy — it may be rejecting certain HTML payloads or the reply_markup structure.
