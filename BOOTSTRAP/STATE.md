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
- ai/*.py DEFAULT_MODEL: openrouter/openai/gpt-4o-mini (verified 2026-10-26)
  (gemini/gemini-3.1-flash-lite-preview -> HTTP 500 via OmniRoute; EVR-0036)
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
- G-0020: COMPLETED 2026-10-26 (EVR-0036)
  ai/* -> openrouter/openai/gpt-4o-mini (json_object OK)
- G-0021: COMPLETED 2026-10-26 (EVR-0037)
  Tech debt triaged; .bet_env backups removed
- G-0022: COMPLETED 2026-10-26 (EVR-0040)
  Stats window by kickoff (ISO or DD.MM HH:MM)
- G-0024: COMPLETED 2026-11-08 (EVR-0042)
  Pipeline: fetch_real_today + OddsEvent converter
- G-0025: COMPLETED 2026-11-08 (EVR-0043)
  Cron: generate-signals.sh (11:00 MSK)
- G-0026: COMPLETED 2026-11-08 (EVR-0044)
  Test isolation: empty tempdir + dummy OMNI_KEY
- G-0028: COMPLETED 2026-11-08 (EVR-0046)
  4 log calls wrapped in _sanitize_error: 1960, 2489, 2547, 2550
- G-0030: COMPLETED 2026-11-08 (EVR-0049)
  /start and /help added to _set_bot_menu commands list; verified via getMyCommands

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

## 2026-11-08
- HEAD BET-ANALYZER: daa37ae (test isolation, pipeline fix, _sanitize_error, /start+/help in menu)
- Baseline: 319 passed, 7 skipped, 2 deselected
- Pipeline: fetch_real_today (Fonbet) + Pinnacle (EVR-0042)
- Cron: resolve-signals (20:30), generate-signals (11:00)
- Tests: isolated from network, dummy OMNI_KEY (EVR-0044)
- Security: 4 log calls use _sanitize_error (EVR-0046, commit 8d31b7f)
- Bot menu: /start, /help added (EVR-0049, commit daa37ae); dshh A36 incident (rewrote file, recovered)
