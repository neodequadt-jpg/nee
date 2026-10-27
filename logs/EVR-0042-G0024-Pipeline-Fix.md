# EVR-0042 — G-0024 fix build_pipeline (PASS)

Object: tg_bot.build_pipeline
Environment: jailLMDE, ~/BET-ANALYZER
Date: 2026-10-27

## Expected
- build_pipeline finds value bets (needs >=2 bookmakers)
- cmd_signals writes to data/backtest/signals/

## Observed
- build_pipeline only had Pinnacle (96 events). Fonbet RPL/Nations/EU returned 0.
- fetch_real_today() worked (30 events) but was not called by build_pipeline.
- Smarkets returned 403 (ignored for now).
- After patch: fonbet today: 30, pinnacle: 96, Matches: 142, Value Bets: 1
  (Sample: Rostov vs Akron draw @ 4.11)
- Normalizer required OddsEvent, raw dicts raised AttributeError -> added converter.

## Verification
cmd_signals() -> writes file to signals/
pytest -q -> 319 passed, 7 skipped
commit -> fix(pipeline) inject fetch_real_today

## Result
PASS.

## Note
Smarkets is 403 Forbidden (blocked IP). Not blocking: Fonbet + Pinnacle
is enough for consensus. Stats will populate after new matches resolve.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
