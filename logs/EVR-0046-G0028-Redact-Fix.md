# EVR-0046 — G-0028 audit _sanitize_error coverage (PASS)

Object: tg_bot.py log calls with bot-token URL
Environment: jailLMDE, ~/BET-ANALYZER, HEAD 592c79b (base), commit 8d31b7f
Date: 2026-11-08

## Expected
- find log calls where bot<digits>:<token> can leak to journalctl
- wrap them in _sanitize_error (existing helper)

## Observed
- dsh-orch.sh probe via dshh@0.2.2-alpha.3 + OmniRoute z-ai/glm-4.6
- dshh returned reasoning summary, NOT LINE | FUNC | REDACTED (A4 confirmed)
- probe interrupted; manual sed confirmed 4 unredacted + 1 already-safe
- L680 already uses _sanitize_error
- L1960, L2489 (P2), L2547, L2550 were unredacted
- second replace run after commit failed with AssertionError
  (idempotency: count=0, no write_text, no side effects)

## Patch
4 replace, assert count==1:
- {_e} -> {_sanitize_error(_e)} at 1960, 2547, 2550
- {e}  -> {_sanitize_error(e)}  at 2489

## Verification
py_compile OK
pytest -q -> 319 passed, 7 skipped, 2 deselected
git diff --stat -> 1 file changed, 4 insertions(+), 4 deletions(-)
commit -> 8d31b7f fix(security): _sanitize_error bot-token in 4 log calls

## Result
PASS.

## Note
dsh-orch.sh probe: A4. Reasoning quality OK (5 candidates, 4 correct).
For structured output consider gpt-4o-mini as agent-default-model.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- CONSTRAINTS: Never Commit Secrets (defense in depth)
