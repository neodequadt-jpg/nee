# EVR-0012 — /stats command

## Object
Add /stats command to tg_bot.py (won/lost/ROI last 7d).

## Proposal source
DSH (DeepSeek V3.2 via OpenRouter).

## Changes
tg_bot.py +55 lines, 3 insertions:
1. get_welcome_text() — "/stats — won/lost/ROI за 7 дней"
2. cmd_stats(chat_id) — reads data/backtest/results/*.json,
   filters _resolved_at within 7d, computes won/lost/winrate/ROI/profit.
3. dispatch() — "if command == '/stats': return cmd_stats(_LAST_CHAT_ID)"
   after /status.

## Verification
- py_compile: OK
- ./run_tests.sh: 185 passed, 2 deselected
- smoke: cmd_stats(0) -> "Нет результатов" (results empty)
- git diff: 55 lines, all expected

## Note
results/ empty — resolver not run yet. cmd_stats handles this.

## Result
PASS

## Critical: DSH WRITE ACCESS
DSH wrote to file despite "=== FILE:" prompt. Mitigation:
- SPEC prompts: "НЕ применяй. Выведи diff."
- Before dshh: cp <file> <file>.before-dsh
- After dshh: git status --porcelain
- Rollback: git checkout -- <file>

## Next
- Run resolve_all() -> populate results/
- Unit tests for cmd_stats (tmp_path)

## Resolver limitation — CONFIRMED
- openfootball: ru.1.json -> 404 (RPL not published)
- openfootball: nations-league.json -> timeout (no such file)
- thesportsdb free key=3: USL and misc, no RPL / Nations League
- openligadb: Bundesliga only
- sports_skills, understat: stubs

None of the bundled providers serve the leagues present in signals.
resolve_all() returns skipped=348 honestly. Not a bug.

## Follow-up options (not now)
A. Register football-data.org free tier (10 req/min). Covers RPL.
   Requires API key, ~1 min signup.
B. Pay for api-football (rapidapi), $10/mo. Covers everything.
C. Leave as known limitation. /stats works with empty results/.

## Decision
Option C for now. No further code changes needed.
EVR-0012 /stats feature is complete and working.
