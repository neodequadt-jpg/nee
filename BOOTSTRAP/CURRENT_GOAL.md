# CURRENT ENGINEERING GOAL

ID: G-0009
Title: scoring/resolver.py tests

## G-0008: COMPLETED
- [x] consensus_per_bookmaker — 2 tests
- [x] ConsensusOutcome — 1 test
- [x] EVR-0009 PASS
- market/consensus.py fully covered (7/7 functions + 1 dataclass)

## G-0009 Next
1. Прочитать scoring/resolver.py целиком
2. Написать тесты:
   - _normalize (edge cases)
   - _parse_kickoff (more formats)
   - _determine_result (score variations)
   - _find_match (fuzzy matching)
   - _fetch_events_for_date (mock requests.get)
   - resolve_all (mock _fetch_events_for_date)
3. Цель: +6-8 тестов, закрыть resolver.py

## Rules
- DSH halucinates — verify each claim
- py_compile after each patch
- One step = one commit
