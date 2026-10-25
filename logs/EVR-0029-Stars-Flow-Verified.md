# EVR-0029: Telegram Stars invoice flow — verified manually

Date: 2026-10-13
Goal: G-0015 (Telegram Stars monetization)

## Object
- tg_bot.py /subscribe → cmd_subscribe → tg_post("sendInvoice")
- /start help menu shows /subscribe

## Environment
- real Telegram, real bot, TG_API_BASE=Cloudflare Worker
- currency=XTR, prices=[{label: "Premium 30 дней", amount: 200}]

## Expected
- /subscribe → invoice with title "BET-ANALYZER Premium", 200 ⭐ button

## Observed
- /start: shows "💎 /subscribe — Premium 200⭐/месяц"
- /subscribe: invoice rendered (title, description, "Заплатить ⭐ 200")

## Result: PASS
## Notes
- Payment NOT confirmed (own account).
- successful_payment covered by 6 unit tests + mock.

## Evidence
- Commits: e2a26c6, 5c5faac, <welcome fix>
- Tests: 300 passed, 7 skipped
