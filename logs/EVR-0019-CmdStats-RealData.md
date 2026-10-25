# EVR-0019: cmd_stats verified on real backtest data

**Date:** 2026-10-12
**Object:** tg_bot.py::cmd_stats(chat_id)
**Status:** PASS

## Environment
- repo: ~/BET-ANALYZER, HEAD: 775e049
- data/backtest/results/: 348 json files (from EVR-0018)

## Expected
cmd_stats reads results/, filters by _resolved_at cutoff (7d), returns
winrate / ROI / profit. Numbers consistent with resolve_all() stats.

## Observed
cmd_stats(0) →
  Stats (7d) — 348 resolved
  Выиграло: 114 / Проиграло: 234
  Winrate: 32.8%
  ROI: +29.92%
  Профит: +14290₽ на 47760₽

Cross-check vs EVR-0018 resolve_all(): won=114, lost=234 — match.

## Result: PASS

## Notes / open
- ROI +29.92% at winrate 32.8% is high. Possible causes:
  * look-ahead bias — signal `odds` may not be closing-line
  * overfit — 348 samples, ~3.5σ above implied
  * kelly_frac=0.5 and bank=10000 hardcoded in cmd_stats
  Validate over longer horizon before treating as edge.
- _resolved_at = now() for all 348 files, so all pass the 7d filter.
  In ~8 days, most will drop out (rolling window by design).
- chat_id argument unused in cmd_stats body — fine for CLI, leftover.

## Files
- tg_bot.py::cmd_stats (unchanged, verified)
