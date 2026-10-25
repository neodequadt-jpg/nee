# EVR-0018: Resolver wired to footbolno — RPL + Nations League resolved

**Date:** 2026-10-12
**Object:** scoring/resolver.py + tests/test_resolver_network.py
**Status:** PASS

## Environment

- repo: ~/BET-ANALYZER, branch main, HEAD: 775e049
- python 3.11.2, venv, requests 2.32.5
- 348 signals: RPL=258, NL-A=61, NL-B=1, NL-C=28

## Expected

1. resolve_all() uses footbolno for RPL and UEFA Nations League.
2. TheSportsDB fallback preserved for other leagues.
3. _get_session() stops reading env proxy (dead :8118 = PRE-THEORY E1).
4. resolved > 0 (was skipped=348 in EVR-0013).
5. Baseline preserved.

## Observed

Before (EVR-0013): checked=348, resolved=0, skipped=348
After  (775e049): checked=348, resolved=348, won=114, lost=234, pending=0, skipped=0

- 348 result files written to data/backtest/results/
- sample: 20260925_175911__Германия__Греция__away.json
  { _result: "away", _score: "0-1", _won: true }

Changes:
- _get_session(): s.trust_env = False; env proxy pickup removed
- FOOTBOLNO_LEAGUES = {RPL:235, NL A/B/C:5}
- _get_footbolno(): lazy singleton FootbolnoProvider
- _determine_result_from_match(m): for Match dataclass
- resolve_all(): route by sig["league"], else TheSportsDB
- tests/test_resolver_network.py: TestGetSession rewritten (env ignored,
  trust_env=False), integration test updated

Baseline:
- before: 207 passed, 2 deselected
- after:  207 passed, 2 deselected
- delta: 0

## Result: PASS

## Notes / open

- TheSportsDB fallback has no active signal coverage (dead in current dataset).
- dsh PI_AI_ERROR on long prompts; resolver patch written manually.
- League routing by exact string match. Follow-up if vocabulary changes.
