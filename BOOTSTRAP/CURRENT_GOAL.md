# CURRENT ENGINEERING GOAL

ID: G-0007
Title: Finish consensus.py tests

## G-0006 progress: PARTIAL
- [x] 9 unit tests for _implied_prob, _remove_margin, _consensus_from_subset (EVR-0007 PASS)
- [ ] build_consensus, evaluate_event — требуют OddsEvent
- [ ] resolver.py — _fetch_events_for_date, resolve_all deeper

## G-0007 Next
1. Изучить OddsEvent (bookmakers/parser.py)
2. 4 unit-теста для build_consensus с минимальными mock-объектами
3. 3 unit-теста для evaluate_event
4. Перейти к resolver.py

## Rules
- DSH halucinates — verify each claim via grep/sed
- py_compile after each patch
- One step = one commit
