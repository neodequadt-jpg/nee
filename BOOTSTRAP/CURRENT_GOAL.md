# CURRENT ENGINEERING GOAL

ID: G-0006
Title: Extend test coverage for scoring/ and market/

## G-0005: COMPLETED
- [x] Separated unit vs integration tests
- [x] pytest.ini with  marker
- [x] 132 unit tests green
- [x] EVR-0006 PASS

## G-0006 Next
1. DSH: propose tests for scoring/resolver.py
2. DSH: propose tests for market/consensus.py
3. Verify proposals with grep/sed before apply
4. Target: at least 3 new unit tests per module

## Rules Reminder
- DSH hallucinates: always verify
- py_compile after each patch
- One step = one commit
