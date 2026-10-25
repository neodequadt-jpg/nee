# EVR-0028: Subscribe Flow — Telegram Stars

## Summary
Added Telegram Stars subscription flow to `tg_bot.py` enabling 200⭐/month Premium purchases via native Telegram invoices.

## Changes in `tg_bot.py`

### 1. Routing in `handle(update)`
- **pre_checkout_query**: checked at the very top of `handle()`, before callback_query/message → calls `_handle_pre_checkout(pq)` and returns
- **successful_payment**: checked right after `message = update.get("message")` → calls `_handle_successful_payment(msg)` and returns
- Both checks occur **before** whitelist verification

### 2. Whitelist bypass
Commands `/start`, `/help`, `/subscribe` are now allowed regardless of `TG_ADMIN_IDS` whitelist:
```python
if cmd in ("/start", "/help", "/subscribe"):
    pass  # разрешено всем
elif TG_ADMIN_IDS and chat_id not in TG_ADMIN_IDS:
    send_message(chat_id, _t(chat_id, "wl_reject", id=chat_id))
    return
```

### 3. `dispatch()` — `/subscribe`
```python
if command == "/subscribe":
    return cmd_subscribe(_LAST_CHAT_ID)
```

### 4. `cmd_subscribe(chat_id)` → str
- If `is_premium(chat_id)`: returns `"💎 Premium активен до <date>"`
- Otherwise: sends invoice via `tg_post("sendInvoice", ...)` with `currency="XTR"`, `prices=[{label, amount: 200}]`, no `provider_token`
- Returns `""` (invoice already sent, dispatch must not send text)

### 5. `_handle_pre_checkout(pq)` → None
- Validates `invoice_payload` starts with `"premium_30d_"`
- Calls `tg_post("answerPreCheckoutQuery", {pre_checkout_query_id, ok})` with `ok=True/False`
- On error: retries with `ok=False`

### 6. `_handle_successful_payment(msg)` → None
- Extracts `chat_id`, `total_amount` from `successful_payment`
- Calls `grant_premium(chat_id, days=30, stars=total_amount)`
- Sends `"✅ Premium активирован на 30 дней. Спасибо!"`

### 7. WELCOME_TEXT
Appended line:
```
💎 /subscribe — Premium 200⭐/месяц (AI без лимита, все сигналы)
```

## New file: `tests/test_subscribe_flow.py`
6 unittest cases (all passing):
| # | Test | Asserts |
|---|------|---------|
| a | `cmd_subscribe` non-premium | `tg_post` called with `sendInvoice`, `XTR`, `amount=200`, no `provider_token` |
| b | `cmd_subscribe` premium | `tg_post` NOT called, result contains `"активен"` |
| c | `_handle_pre_checkout` valid payload | `ok=True` |
| d | `_handle_pre_checkout` invalid payload | `ok=False` |
| e | `_handle_successful_payment` | `grant_premium(days=30, stars=200)` called |
| f | `_handle_successful_payment` | `send_message` with `"активирован"` |

## Verification
```
python -m py_compile tg_bot.py          # OK
.venv/bin/python -m pytest tests/test_subscribe_flow.py -v  # 6 passed
```

## Key design decisions
- **XTR currency** (Telegram Stars): no `provider_token` sent — required by Telegram API for Stars payments
- **Stars are integers**: `total_amount` for XTR is whole stars, not cents (unlike fiat currencies)
- **Payload format**: `premium_30d_{chat_id}_{timestamp}` — validated in pre_checkout for basic integrity
- **Pure requests + stdlib**: no aiogram, only existing `tg_post(method, json_data)` and `send_message()`
