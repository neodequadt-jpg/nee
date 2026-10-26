# EVR-0040 — G-0022 fix 7d stats window (PASS)

Object: tg_bot.cmd_stats, scoring.resolver
Environment: jailLMDE, ~/BET-ANALYZER, HEAD 93721a9
Date: 2026-10-26

## Expected
- cmd_stats filters by kickoff, not _resolved_at
- resolver preserves _resolved_at if file already exists
- py_compile OK, pytest 319/7

## Observed
- resolver.py:225 set _resolved_at = now on every run
- cmd_stats filtered by _resolved_at -> always saw 90 files as "last 7 days"
- stats stuck at Winrate 20.0%, ROI +55.49%
- kickoff format in data: '27.09 19:00' (not ISO) -> needed fallback parser

## Patch
- resolver: load existing out file, preserve _resolved_at
- cmd_stats: parse kickoff (ISO or DD.MM HH:MM), fallback to _resolved_at
- year inference: if parsed date > now, subtract 1 year

## Verification
py_compile exit=0
pytest -q -> 319 passed, 7 skipped
git diff --stat -> 2 files, +34/-5
cmd_stats(0) -> "Нет результатов за последние 7 дней" (all 90 records
  from 2026-09-26/27 fall outside 7d window — correct)
commit -> bfef93e fix(stats): filter 7d by kickoff

## Result
PASS.

## Note
- Stats will update as new resolved signals arrive (kickoff within 7d).
- Legacy records without kickoff fall back to _resolved_at (best effort).

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
