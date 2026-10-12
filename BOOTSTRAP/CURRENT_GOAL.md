# CURRENT ENGINEERING GOAL

ID: G-0012
Title: Run resolver + cmd_stats tests

## G-0011: COMPLETED
- [x] /stats command added (EVR-0012 PASS)
- [x] 185 tests passed
- [x] DSH write-access documented

## G-0012 Next
1. Run resolve_all() — populate data/backtest/results/
2. Verify cmd_stats on real data
3. Unit tests for cmd_stats (tmp_path)
4. Optional: dispatch(/stats) test

## Rules
- DSH WRITES to files — git status after each dshh
- py_compile after each patch
- One step = one commit
