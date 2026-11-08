# EVR-0044 — G-0026 isolate resolver test + dummy OMNI_KEY (PASS)

Object: tests/test_resolver.py, tests/conftest.py
Environment: jailLMDE, ~/BET-ANALYZER, HEAD 9005c5b
Date: 2026-11-08

## Expected
- test_resolve_all_shape performs no real HTTP requests
- pytest baseline 319/7 restored

## Observed
- test_resolve_all_shape: real signals dir -> footbolno.ru/thesportsdb
  ConnectTimeout (15s)
- After resolver fix, 3 more failures in test_tg_resilience.py with
  RuntimeError("OMNI_KEY not set"): test_build_falls_back_when_value_single_match,
  test_build_handles_none_content, test_build_handles_non_json_content
- Root: EVR-0032 strict OMNI_KEY; pytest green before only because
  ~/.bet_env was sourced in that shell
- First conftest patch attempt (insert after imports) placed code
  INSIDE the module docstring -> silent no-op; reverted via git checkout
- Second attempt appended at EOF but dummy 'test-dummy-...' not 'sk-' ->
  test_tg_chat.py:356 skipUnless(startswith('sk-')) skipped one test -> 318/8
- Third attempt: dummy 'sk-test-dummy-not-used-in-assertions' -> 319/7

## Patch
1. tests/test_resolver.py: wrap resolve_all() in TemporaryDirectory,
   patch SIGNALS_DIR/RESULTS_DIR to empty dirs.
2. tests/conftest.py (EOF): os.environ.setdefault("OMNI_KEY", "sk-test-dummy-...")

## Verification
pytest -q -> 319 passed, 7 skipped, 2 deselected
pytest tests/test_tg_chat.py -q -> 68 passed, 2 deselected
pytest tests/test_tg_resilience.py -q -> 18 passed
pytest tests/test_resolver.py -q -> 9 passed in ~1s (was 15s timeout)

## Result
PASS.

## Note
PRETHEORY candidates:
- A20: tests must not depend on ~/.bet_env being sourced.
- A21: for conftest.py, append at EOF (outside docstring).
- A22: dummy secret must match tests' format guard (sk- prefix).

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
