# EVR-0007 — Consensus Module Tests

## Object
Add unit tests for market/consensus.py (previously untested).

## Environment
- LMDE, .venv/bin/python (pytest 9.1.1)
- No network: pure logic functions

## Changes
New file tests/test_consensus.py with 9 tests:

### TestImpliedProb (2)
- test_normal_odds — 2.0 -> 0.5, 4.0 -> 0.25
- test_invalid_odds — None, 0, 1.0, 0.5 -> 0.0

### TestRemoveMargin (3)
- test_normalizes — [0.5,0.5,0.5] -> sum=1
- test_zero_total_returns_unchanged — [0,0,0] -> [0,0,0]
- test_single_prob_normalized_to_one — [0.5] -> [1.0]

### TestConsensusFromSubset (4)
- test_three_way_median — 3 bk, prob=0.5, sources=3
- test_three_way_skips_none_rows — 3 bk, 1 empty -> sources=2
- test_two_way_skips_draw_outcome — 2-way, draw -> sources=0
- test_empty_subset — {} -> (0.0, 0.0, 0)

## Verification
- py_compile: OK
- pytest tests/test_consensus.py: 9/9 PASSED in 1.49s
- ./run_tests.sh: 141 passed, 2 deselected

## Result
PASS

## Coverage progress
market/consensus.py:
- covered: _implied_prob, _remove_margin, _consensus_from_subset
- uncovered: build_consensus, consensus_per_bookmaker, evaluate_event, ConsensusOutcome

## Next
- Tests for build_consensus with mocked OddsEvent
- Tests for evaluate_event
