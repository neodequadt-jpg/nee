# CURRENT ENGINEERING GOAL

ID: G-0005
Title: Tests + docs via DSH

## G-0002: COMPLETED (Smarkets + Telegram stabilization)
- [x] Smarkets timeout=15, retries=3
- [x] Telegram HTTP_TIMEOUT=25
- [x] WireGuard split-tunnel
- [x] Static resolv.conf
- [x] Valid BOT_TOKEN
- [x] EVR-0003 PASS

## G-0003: COMPLETED (DSH TPM bottleneck)
- [x] OpenRouter via WG (8.6.0.0/16, 8.47.0.0/16)
- [x] DeepSeek V3.2 (128K ctx)
- [x] DSH agentic loop works
- [x] EVR-0004 PASS

## G-0004: COMPLETED (DSH code review)
- [x] Reviewed smarkets_provider.py
- [x] Verified 7 findings (only 1 real: duplicate lo/hi)
- [x] Refactored: hoisted now/lo/hi (commit a859c90)
- [x] EVR-0005 PARTIAL (DSH has hallucinations)
- [x] NEE under git (commit d213654)
- [x] Removed .env from git history

## Key Rules
1. DSH findings require grep/sed verification before action.
2. Never commit .env (add to .gitignore).
3. One engineering step = one commit.

## G-0005 Next
1. DSH: write tests for scoring/resolver.py
2. DSH: write tests for market/consensus.py
3. DSH: add docstrings to key modules
4. DSH: analyze tg_bot.py for potential improvements
