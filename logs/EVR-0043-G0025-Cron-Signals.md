# EVR-0043 — G-0025 automate daily signals (PASS)

Object: ~/generate-signals.sh, crontab
Environment: jailLMDE, ~/BET-ANALYZER
Date: 2026-11-08

## Expected
- cron job calls cmd_signals daily
- signals saved to data/backtest/signals/

## Observed
- generate-signals.sh created, chmod +x, tested manually: exit=0
- new signal file: 20261108_005137.json
- crontab entry added: 0 11 * * * ~/generate-signals.sh
- text patched: Smarkets -> Pinnacle (unicode string match)
- bot restarted

## Verification
tail -5 ~/logs/signals.log -> signals text present
ls data/backtest/signals/ -> new file exists
crontab -l -> job present
pytest -q -> 319 passed, 7 skipped

## Result
PASS.

## Note
Cron runs at 11:00 MSK. Signal generation will happen automatically
and fill /stats after matches resolve (23:30 MSK via resolver).

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
