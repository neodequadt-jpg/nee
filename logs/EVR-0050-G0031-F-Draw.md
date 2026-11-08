# EVR-0050 — G-0031 parse F_DRAW in fetch_real_today (PASS)

Object: bookmakers/fonbet_extended.py, tg_bot.py
Environment: jailLMDE, ~/BET-ANALYZER, HEAD daa37ae
Date: 2026-11-08

## Expected
- fetch_real_today returns odds_draw
- build_pipeline passes it to OddsEvent
- pytest 319/7, no new API calls

## Observed (before)
- fetch_real_today parsed F_HOME/F_AWAY only, draw dropped
- fetch_rpl_odds + fetch_european_cups already parsed F_DRAW
- build_pipeline set OddsEvent.odds_draw=None for all fetch_real_today events
- Result: draw consensus = 0 for all non-RPL football

## Patch (3 replace, assert count==1)
1. import: F_AWAY,F_HOME -> F_AWAY,F_DRAW,F_HOME
2. fetch_real_today: + 'odds_draw': odds.get(F_DRAW)
3. build_pipeline: odds_draw=None -> odds_draw=d.get("odds_draw")

## Verification
py_compile OK
pytest -q -> 319 passed, 7 skipped, 2 deselected
git diff --stat -> 2 files, +3/-2
cmd_value: 114 matches, 0 value bets (efficient market)
fetch_real_today probe: 30 events, 20 with draw (10/10 football, 10/10 hockey, 0/10 tt)
  - sample: Фиорентина vs Ювентус | D=3.4; Атлетико vs Барселона | D=4.5

## Result
PASS.

## Note
F_DRAW is in same API response as F_HOME/F_AWAY -> 0 new HTTP calls.
Draw consensus now possible wherever Pinnacle covers the league.
0 value today is normal (efficient market), not a regression.
Next: G-0033 (hockey/tennis via Pinnacle 2-way, high value-rate)
or G-0032 (add soccer keys, watch quota).

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
