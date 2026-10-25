# EVR-0021: G-0013 Bonus track — monitor + tracker + matched betting + bookmaker registry

**Date:** 2026-10-12
**Object:** scoring/bonus_monitor.py, bonus_tracker.py, matched_betting.py, bookmaker_monitor.py
**Status:** PASS

## Environment
- repo: ~/BET-ANALYZER, branch: feat/g0013-bonus-tracker
- baseline before: 216 passed (main, 170b2c3)
- pytest 9.1.1, python 3.11.2, requests 2.32.5

## Expected
Four modules + data files + tests:
1. bonus_monitor: fetch metaratings.ru, normalize, snapshot diff
2. bonus_tracker: manual registry, validate, auto-expire
3. matched_betting: SNR lay formula, find_optimal
4. bookmaker_monitor: 14 BK registry (7 RU legal + 7 offshore), 0-100 scoring
5. Tests: no network, all green

## Observed

### bonus_monitor (commit ac429c9)
- Source: https://metaratings.ru/bonuses/
- Method: __NEXT_DATA__ regex, dedup by id
- Raw 58 items -> 33 unique after dedup
- 17 unique bookmakers (winline, fonbet, pari, marathonbet, olimp, ...)
- Bonus dataclass with amount parse, bookmaker via analytics.bookmaker_name

### bonus_tracker (commit 7192390)
- data/bonuses.json: manual registry (Winline, PARI examples)
- validate: type/amount/odds/expiry/status checks
- list_active: status=='active' AND not expired
- Bookmaker field added post-review

### matched_betting (commit 503cb6a)
- calc_lay(10000, 2.0, 2.05, 0.02):
    lay_stake=4926.11, liability=5172.41, guaranteed=4827.59
- find_optimal: maximize guaranteed over lay range
- guards: back>1, lay>1, free_bet>0, commission in [0,1)

### bookmaker_monitor (commit 212c157)
- data/bookmakers.json: 14 records
- score = license_weight + max(0,30-days*3) + max(0,30-issues*10)
- Winline=87, PARI=87, Fonbet=84 (RU legal)
- 1xBet=24, Cosmobet=15, Melbet=50 (offshore)
- 7 recommended (>=70), 5 risky (<50)

### Tests
- test_bonus_monitor.py: 13 passed
- test_bonus_tracker.py: 18 passed
- test_matched_betting.py: 10 passed
- test_bookmaker_monitor.py: 11 passed
- Total: 52 new tests, all no-network

### Baseline
- before: 216 passed, 2 deselected
- after:  268 passed, 2 deselected

## Result: PASS

## Notes / open
- Bonus model: dict[bookmaker, bonus] — один бонус на БК. Реальные БК часто
  дают несколько (PARI: 22000 + 1337). Расширение до dict[bonus_id, ...]
  — follow-up.
- metaratings.ru: 1 bonus без bookmaker (unknown). Не критично.
- Offline-matched betting formula для бонусов с вейджером (SR) не реализована.
  Только SNR.
