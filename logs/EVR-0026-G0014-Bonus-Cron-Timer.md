# EVR-0026: G-0014 Bonus snapshot cron — full closure

Date: 2026-10-12
Goal: G-0014 Bonus snapshot cron + Telegram alert

## Object
- scripts/bonus_cron.py + tests/test_bonus_cron.py
- systemd --user: bonus-cron.service + bonus-cron.timer

## Environment
- jail@jailLMDE, systemd --user, Linger=yes
- venv .venv/bin/python (requests 2.32.5, pytest 9.1.1)
- env: ~/.bet_env (6 vars)

## Expected
- Fetch metaratings bonuses → diff → save → alert on change
- Idempotent when no changes
- Timer 4x/day MSK, survives logout

## Observed
- dry-run 18:01:49: 58 raw → 33 dedup, new=33, status=0/SUCCESS
- real run 18:03:53: snapshot 12 914 B, alert to 6 admins, status=0/SUCCESS
- idempotency 18:04:51: new=0 gone=0 changed=0, no alert, status=0/SUCCESS
- timer: enabled, active, Linger=yes

## Result: PASS

## Evidence
- Commits: 61e24db (feat), 757e6f3 (fix tg_bot globals), 02c100f (gitignore)
- Tests: 293 passed, 2 deselected (+16 от baseline 277)

## Steps closed: 1,2,3,4,5
## Known limits
- 6 админов получают каждый alert
- metaratings формат может измениться
