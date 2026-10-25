# EVR-0013 — resolve_all() execution (G-0012 step 1)

## Object
Run `resolve_all()` → populate `data/backtest/results/`. No code changes.
Record outcome and confirm known limitation.

## Pre-run state
- `data/backtest/results/` — empty (0 files)
- Signal files: 120 JSON files in `data/backtest/signals/`
- Total signals: 348
- Expected: skipped=348 (resolver known limitation, per EVR-0012)

## Execution
```python
from scoring.resolver import resolve_all
result = resolve_all()
```

## Output
```json
{
  "checked": 348,
  "resolved": 0,
  "won": 0,
  "lost": 0,
  "pending": 0,
  "skipped": 348
}
```

## Post-run state
- `data/backtest/results/` — still empty (0 files written)
- All 348 signals skipped — **matches expected** skipped=348

## Skip reason analysis
1. **Kickoff parsing**: OK — all signals have valid `kickoff` format (`DD.MM HH:MM`).
2. **Future check**: PASS — system clock is 2026-10-12 MSK; signal dates are 2026-09-25/26
   (past), so `kick_ts > now - 3h` is False. Signals proceed to API lookup.
3. **API lookup**: TheSportsDB `eventsday.php?d=2026-09-26&s=Soccer` returns only 3 U21 events
   (Ukraine U21, Croatia U21, Latvia U21). No senior-team matches present.
4. **`_find_match`**: Returns None for all 348 signals → `stats["skipped"] += 1`.

Root cause: TheSportsDB free tier (key=3) does not carry the leagues in signals
(RPL, Nations League senior). This was already documented in EVR-0012 §Resolver limitation.

## Summary

| Metric   | Value |
|----------|-------|
| checked  | 348   |
| resolved | 0     |
| won      | 0     |
| lost     | 0     |
| pending  | 0     |
| skipped  | 348   |
| result files | 0 |

## Verification
- skipped=348 **matches** expected (resolver known limitation)
- No code or resolver modifications made
- `data/backtest/results/` state: empty (correct — nothing resolved)

## Result
PASS — resolve_all() ran cleanly, outcome matches documented limitation.

## Note
EVR written to workspace root (not ~/NEE/logs/) due to read-only filesystem on /home/jail/NEE/logs.
Copy to ~/NEE/logs/ when FS is writable again.

## Next
- Option A: football-data.org free tier (covers RPL, requires API key)
- Option B: api-football paid tier ($10/mo, covers everything)
- Option C: leave as known limitation (current decision per EVR-0012)
