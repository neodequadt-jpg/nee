# CURRENT ENGINEERING GOAL

ID: G-0004
Title: Practical use of DSH in BET-Analyzer

## Done
- [x] G-0002: Smarkets + Telegram stabilized (EVR-0003 PASS)
- [x] G-0003: DSH on OpenRouter via WG (EVR-0004 PASS)
- [x] G-0004 step 1: DSH code review + verification (EVR-0005 PARTIAL)

## Key Rules (learned)
1. DSH findings require grep/sed verification
2. DSH is best for: reading files, structured extraction, proposals
3. DSH is not reliable for: unverified claims about dead code / bugs

## Next Steps (G-0004)
1. Refactor: smarkets_provider.py — extract now/lo/hi (minor)
2. Use DSH to write tests for scoring/ and market/
3. Use DSH to add docstrings to key modules
4. Periodic DSH checks of BET-Analyzer (weekly review)
