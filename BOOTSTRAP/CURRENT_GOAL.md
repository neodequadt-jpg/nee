# CURRENT ENGINEERING GOAL

ID: G-0011
Title: Next module tests or resolve_all

## G-0010: COMPLETED
- [x] _get_session — 4 tests
- [x] _fetch_events_for_date — 8 tests
- [x] integration reuse session — 2 tests
- [x] EVR-0011 PASS (14 tests, 2 DSH bugs fixed)
- scoring/resolver.py: 6/7 functions covered

## G-0011 options
A) resolve_all — requires tmp_path + mocking filesystem
B) next module (tg_bot handlers, scoring/portfolio)
C) pause, review overall coverage

## Rules
- DSH generates ~85% correct; verify each
- py_compile after each patch
- One step = one commit
