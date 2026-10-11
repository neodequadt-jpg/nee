# EVR-0009 — consensus_per_bookmaker + ConsensusOutcome

## Object
Close remaining test gaps in market/consensus.py.

## Proposal source
DSH (DeepSeek V3.2 via OpenRouter).

## Changes (tests/test_consensus_mocks.py)
### TestConsensusPerBookmaker (3)
- test_consensus_per_bookmaker_basic — 3 BK, structure + values
- test_consensus_per_bookmaker_skip_single_bk — 1 BK -> {}
- test_consensus_outcome_fields — dataclass field construction

## Bug found during first run
Initial expectation: all three outcomes at 0.5.
Reality: fair odds (h, d, a) = (2.0, 4.0, 4.0) -> home=0.5, draw=0.25, away=0.25.
Test fixed to expect per-outcome values.

## Verification
- py_compile: OK
- pytest tests/test_consensus_mocks.py: 10/10 PASSED in 1.34s
- ./run_tests.sh: 151 passed, 2 deselected

## Result
PASS

## Coverage: market/consensus.py
7/7 functions + 1 dataclass covered.

## Lesson (ARTEM: Reality Before Assumptions)
Both author and DSH assumed equal probabilities from "fair" 3-way odds.
The test caught the wrong assumption. Test-then-fix is the correct
response — assertions follow verified code, not guesses.

## Next
G-0009 — scoring/resolver.py tests.
