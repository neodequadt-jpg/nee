# EVR-0020: cmd_stats unit tests

**Date:** 2026-10-12
**Object:** tests/test_cmd_stats.py
**Status:** PASS

## Environment
- repo: ~/BET-ANALYZER, HEAD after: <commit hash>
- pytest 9.1.1, python 3.11.2

## Expected
9 unit tests cover cmd_stats aggregation: empty / win / loss / mixed /
old excluded / naive tz / malformed / zero stake.

## Observed
9 passed. Baseline: 207 -> 216 passed (2 deselected).

Cases:
1. empty results dir -> "Нет результатов"
2. missing results dir -> "Нет результатов"
3. single win -> winrate 100%, ROI +100%
4. single loss -> winrate 0%, ROI -100%
5. mixed 1W/1L -> winrate 50%
6. old (_resolved_at 30d) excluded by 7d cutoff
7. naive iso treated as UTC, included
8. malformed json skipped, good files counted
9. zero kelly -> ROI 0%, no ZeroDivisionError

Approach: pytest tmp_path + monkeypatch.chdir, no network, no mocks of
filesystem. Results dir created relative to tmp (matches cmd_stats hardcoded
Path("data/backtest/results")).

## Result: PASS

## Files
- tests/test_cmd_stats.py (new, 9 tests)

## Notes
- EVR-0019 verified cmd_stats on real 348 files; EVR-0020 locks behavior.
