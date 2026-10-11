# CURRENT ENGINEERING GOAL

ID: G-0008
Title: Complete consensus + start resolver tests

## G-0006 progress: 5/7 functions covered
- [x] _implied_prob, _remove_margin, _consensus_from_subset (EVR-0007, 9 tests)
- [x] build_consensus, evaluate_event (EVR-0008, 7 tests)
- [ ] consensus_per_bookmaker — 1-2 tests
- [ ] ConsensusOutcome dataclass — trivial

## G-0008 Next
1. 2 теста для consensus_per_bookmaker
2. 1 тест на поля ConsensusOutcome
3. Перейти к scoring/resolver.py:
   - _fetch_events_for_date (mock requests)
   - resolve_all (mock _fetch_events_for_date)
4. Цель: +5-7 тестов на resolver

## Rules
- DSH halucinates — verify each claim
- py_compile after each patch
- One step = one commit
