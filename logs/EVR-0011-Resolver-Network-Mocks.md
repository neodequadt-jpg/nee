# EVR-0011 — Resolver Network Mocks

## Object
Mock network layer in scoring/resolver.py (no real HTTP).

## Proposal source
DSH (DeepSeek V3.2 via OpenRouter) via dsh-loop.sh.
NOTE: DSH became unavailable mid-run (deepseek-v3.2 cooldown),
but the file was written by DSH before the error. Reviewed manually.

## Changes
tests/test_resolver_network.py, 14 tests:

### TestGetSession (4)
- no proxy env
- HTTP_PROXY env
- HTTPS_PROXY over HTTP_PROXY priority
- only HTTPS_PROXY

### TestFetchEventsForDate (8)
- 200 + events
- 200 + empty events
- 200 + no events key
- 404 status
- exception
- json decode error
- timeout
- arbitrary date

### TestIntegrationWithSession (2)
- proxy + fetch integration
- multiple calls reuse session

## Bugs found (DSH proposal quality)
1. test_session_without_proxy used
   `hasattr(mock, 'proxies') and mock.proxies` on MagicMock.
   MagicMock always has attributes -> always truthy -> false failure.
   FIXED: used FakeSession class with default proxies={}.
2. test_multiple_calls_reuse_session used assert_has_calls on
   MagicMock.get, which also counted nested .json() calls.
   FIXED: used side_effect list + call_args_list + call_count.

## Verification
- py_compile: OK
- pytest tests/test_resolver_network.py: 14/14 PASSED (expected)
- ./run_tests.sh: 185 passed (expected)

## Result
PASS (after 2 manual fixes)

## Lesson (ARTEM)
DSH generates ~85% correct tests. Remaining 15% are MagicMock
misunderstandings. Manual verification after each DSH proposal
is not optional — it's the only reason the suite stays green.

## Coverage (scoring/resolver.py)
Covered: _normalize, _parse_kickoff, _determine_result, _find_match,
         _get_session, _fetch_events_for_date
Uncovered: resolve_all (file IO + orchestration)

## Next
- Optional: mock resolve_all with tmp_path.
- Or: switch to next module in BET-ANALYZER.
