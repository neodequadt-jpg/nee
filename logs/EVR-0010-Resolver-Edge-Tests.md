# EVR-0010 — Resolver Edge-Case Tests

## Object
Edge-case tests for scoring/resolver.py pure-logic functions.

## Proposal source
DSH (DeepSeek V3.2 via OpenRouter).

## Verification before apply
DSH proposed 6 tests. Verified against source. Found 2 wrong
assertions in _parse_kickoff:
- "26.09  21:45" (double space): DSH expected None, code uses
  .strip().split() -> valid. Fixed: assertIsNotNone.
- "26.09 21:45 " (trailing space): DSH expected None, .strip()
  removes it. Fixed: assertIsNotNone.

## Changes
New file tests/test_resolver_edge.py, 20 tests:

### TestNormalizeEdge (4)
### TestParseKickoffEdge (6)
### TestDetermineResultEdge (5)
### TestFindMatchEdge (5)

## Verification
- py_compile: OK
- pytest tests/test_resolver_edge.py: 20/20 PASSED in 1.87s
- ./run_tests.sh: 171 passed, 2 deselected

## Result
PASS

## Coverage (scoring/resolver.py)
- _normalize, _parse_kickoff, _determine_result, _find_match: edge cases
- Uncovered: _get_session, _fetch_events_for_date, resolve_all (network)

## Lesson (ARTEM)
DSH edge-case proposals need verification. 2 of 6 _parse_kickoff
assertions were wrong on first pass. DSH enumerates cases well,
but doesn't know how code actually handles them.

## Next
G-0010 — mock requests for _fetch_events_for_date / resolve_all.
