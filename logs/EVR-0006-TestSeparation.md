# EVR-0006 — Test Separation

## Object
Split unit vs integration tests in BET-ANALYZER.

## Environment
- LMDE
- pytest 9.1.1 in .venv
- Live network: Fonbet, Smarkets, Telegram via WG

## Problem
`test_pipeline_has_value_bets` failed on empty market. Test is
integration-style (hits live data) but ran as unit → CI red.

## Changes
1. run_tests.sh: fixed duplicate "$@" (introduced earlier).
2. pytest.ini: marker `integration` + addopts `-m "not integration"`.
3. tests/test_tg_chat.py: marked 2 methods @pytest.mark.integration.

## Result
- Default run: 132 passed, 2 deselected in ~46s.
- Integration run: 1 passed, 1 failed (no value_bets on market — expected).

## Notes
- Failure of integration test is not a code regression.
- DSH suggestion verified before apply (import block matched).
- Fixed indentation bug in first patch attempt (decorator at col 0).
- Lesson: python3 -m py_compile after every patch, before commit.

## Result
PASS
