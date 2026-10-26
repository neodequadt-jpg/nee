# ENGINEERING STATE

## Ecosystem
NEE

## Current Repository
BET-ANALYZER

## Stack
- opera-proxy (127.0.0.1:18080)
- OmniRoute (127.0.0.1:20128) -> VPS SOCKS5 (45.11.24.103:1080)
- Telegram bot

## LLM (verified 2026-10-26)
- Chat models (tg_bot.py:91-92): bet-edge-primary, bet-edge-free via OmniRoute
- ai/*.py DEFAULT_MODEL: gemini/gemini-3.1-flash-lite-preview
  (Gemini direct BLOCKED: EEA requires billing; Step C pending, see G-0020)
- OmniRoute auth: Bet_analyzer key in ~/.bet_env (600), /v1/models -> 200,
  count=1132, bet-edge-primary/free PRESENT (EVR-0034)
- Fallback: none

## Known Issues
- Gemini API unavailable from EEA without billing (ai/*.py uses this model)
- Smarkets timeouts (read timeout=6)
- Telegram getUpdates timeouts (read timeout=8)
- OmniRoute: 2 orphan active keys (bet-analyze, CLI Auto-Key) — revoke (separate goal)
- EVR-0023 missing (referenced by commit 09a170a) — tech debt

## Verified
- EVR-0002 PASS: nee + OmniRoute + VPS + Bootstrap
- EVR-0031 PASS: G-0015 already-done in ab0eab9; baseline 319/7 (not 293)
- EVR-0032 PASS: P1 fallback sk-8445… removed from ai/* (commit 0bcad9f)
- EVR-0033 PASS: unverified model swap rejected (no commit)
- EVR-0034 PASS: OmniRoute auth fixed via Bet_analyzer key; /v1/models 200

## Current Priority
- See ~/NEE/BOOTSTRAP/CURRENT_GOAL.md (G-0018 active at 2026-10-26)

## BET-ANALYZER Resolver (2026-10-12)
- Status: RESOLVED via footbolno.ru (CC BY 4.0, no key)
- Before: skipped=348 (TheSportsDB free: no RPL, no Nations League)
- After: resolved=348 (won=114, lost=234) — EVR-0018
- Providers: providers/footbolno.py (RPL id=235, UEFA NL id=5)
- Env proxy: http_proxy=:8118 is DEAD — sessions use trust_env=False

## Operational Pre-Theory
- ~/NEE/ARTEM-PRETHEORY.md (v0.1, 2026-10-12)
- Rules from real incidents; one rule = one incident
- Referenced from CONSTRAINTS.md

## Goals
- G-0011: COMPLETED (EVR-0012)
- G-0012: COMPLETED 2026-10-12 (EVR-0018, 0019, 0020)
  resolver: RPL+NL via footbolno, 348/348 resolved
  cmd_stats: verified, 9 unit tests
  baseline: 185 -> 216 passed
- G-0013: COMPLETED 2026-10-12 (EVR-0021)
  bonus_monitor + bonus_tracker + matched_betting + bookmaker_monitor
  data/bonuses.json, data/bookmakers.json
  baseline: 216 -> 268 passed
- G-0015: COMPLETED (already-done in ab0eab9) — closed by EVR-0031
  cmd_bonuses:2012, dispatch:2147, callback:2201, keyboard:292/319, welcome:348
- G-0017: COMPLETED 2026-10-26 (EVR-0034)
  OmniRoute auth: Bet_analyzer key in ~/.bet_env (600); /v1/models 200, count=1132

## 2026-10-12 (evening)
- G-0014 closed: bonus_cron.py + systemd timer (61e24db, 757e6f3, 02c100f)
- Baseline: 293 passed, 2 deselected (superseded 2026-10-26)
- bonus-cron.timer: enabled, Linger=yes
- snapshot: data/bonuses_snapshot.json (33 bonuses), gitignored
- OmniRoute поднят вручную (autostart ломается headless)

## 2026-10-26
- HEAD BET-ANALYZER: 0bcad9f (P1 security)
- Baseline: 319 passed, 7 skipped, 2 deselected
- OmniRoute auth fixed: Bet_analyzer key (0ba95930…) from api_keys
- .omniroute/.env chmod 600 (was 644)
- G-0015 closed (already-done); G-0017 closed (EVR-0034)
