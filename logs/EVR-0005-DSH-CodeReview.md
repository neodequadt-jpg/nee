# EVR-0005 — DSH Code Review

## Object
DSH (DeepSeek V3.2 via OpenRouter) review of bookmakers/smarkets_provider.py

## Purpose
Test agentic capability: can DSH perform structured code review?

## Findings reported vs verified

| # | Finding | DSH verdict | Verified |
|---|---------|-------------|----------|
| 1 | _bp_to_odds dead | (initial claim) | FALSE — called at line 160 |
| 2 | _extract_league dead | (initial claim) | FALSE — called at line 171 |
| 3 | duplicate lo/hi | FALSE | PARTIAL — lines 87-88 vs 93-94 |
| 4 | duplicate deadline check | FALSE | FALSE |
| 5 | quotes.get bug | CONFIRMED | FALSE — intentional int/str fallback |
| 6 | market_id None | FALSE | FALSE |
| 7 | redundant `or {}` | UNCERTAIN | FALSE — protects against None |

## Result
PARTIAL

## Key lesson
DSH is useful for structured output with line numbers, but its findings
contain hallucinations. Every claim must be verified via grep/sed
before any action. This matches ARTEM: Evidence Before Authority.

## Change proposals (minimal)
- Refactor: extract `now/lo/hi` computation to top of fetch_events (1-line value)
- No action on other findings — they are not bugs
