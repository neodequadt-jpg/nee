# EVR-0008 — Consensus Mock Tests

## Object
Cover build_consensus / evaluate_event with mocked OddsEvent.

## Environment
- pytest 9.1.1, no network
- Uses real OddsEvent dataclass
- BK registry: Фонбет, Винлайн (legal), Smarkets (exchange)

## Changes
tests/test_consensus_mocks.py, 7 tests:

### TestBuildConsensus (4)
- test_empty_events -> {}
- test_three_way_consensus -> home/draw/away, sources=2
- test_two_way_no_draw -> only home/away
- test_odds_map_populated -> bookmaker_odds correct

### TestEvaluateEvent (3)
- test_no_data -> {"status": "no_data"}
- test_status_ok_shape -> event/consensus/best_odds present
- test_exchange_excluded_from_best_odds -> Smarkets not in best_odds

## Verification
- py_compile: OK
- pytest tests/test_consensus_mocks.py: 7/7 PASSED in 1.47s
- ./run_tests.sh: 148 passed, 2 deselected

## Result
PASS

## Coverage progress (market/consensus.py)
Covered: _implied_prob, _remove_margin, _consensus_from_subset,
         build_consensus, evaluate_event
Uncovered: consensus_per_bookmaker, ConsensusOutcome dataclass
