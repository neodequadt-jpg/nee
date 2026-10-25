# EVR-0027: Subscribers Storage (Telegram Stars)

**Date:** 2025-07-11
**Scope:** `tg_bot.py`, `data/subscribers.json`, `tests/test_subscribe.py`
**Status:** ✅ Done

## What

Added premium subscription storage layer to `tg_bot.py` for Telegram Stars payments.

## Changes

### `tg_bot.py` — 4 new functions (helpers block, before `cmd_status`)

| Function | Purpose |
|---|---|
| `_load_subscribers() -> dict` | Load `data/subscribers.json`; returns `{}` if missing |
| `_save_subscribers(d: dict) -> None` | Atomic write via `tempfile.mkstemp` + `os.replace` |
| `is_premium(chat_id: int) -> bool` | `True` iff `expiry_ts > time.time()` |
| `grant_premium(chat_id: int, days=30, stars=0) -> None` | Grant/extend premium; increments `purchase_count`, adds `stars` |

**Key logic:**
- If already premium → extend from current `expiry_ts` (not from now)
- If expired or new → set `expiry_ts = now + days * 86400`
- `chat_id` stored as **string key** in JSON (per spec), converted to `int` on read
- `import tempfile` added to top-level imports

### `data/subscribers.json`

Initialized as `{}`. Added to `.gitignore`.

### `tests/test_subscribe.py` — 8 test cases (all pass)

| # | Test | Result |
|---|---|---|
| a | `is_premium`: empty file → `False` | ✅ |
| b | `is_premium`: expired → `False` | ✅ |
| c | `is_premium`: active → `True` | ✅ |
| d | `grant_premium`: fresh → `expiry ≈ now + 30d` | ✅ |
| e | `grant_premium`: extend → `expiry = old + 30d` | ✅ |
| f | `grant_premium`: `purchase_count++`, `total_stars += stars` | ✅ |
| g | `_save_subscribers`: `os.replace` called (atomic) | ✅ |

## Verification

```
python -m py_compile tg_bot.py   # OK
.venv/bin/python -m pytest tests/test_subscribe.py -v   # 8 passed
```

## Storage format

```json
{
  "7570616111": {
    "expiry_ts": 1792000000,
    "paid_ts": 1791000000,
    "total_stars": 200,
    "purchase_count": 1
  }
}
```
