# ENGINEERING STATE

## Ecosystem
NEE

## Current Repository
BET-ANALYZER

## Stack
- opera-proxy (127.0.0.1:18080)
- OmniRoute (127.0.0.1:20128) -> VPS SOCKS5 (45.11.24.103:1080)
- Telegram bot

## LLM
- Primary: groq/openai/gpt-oss-120b (WORKS via VPS)
- Gemini: BLOCKED (EEA requires billing)
- Fallback: none

## Known Issues
- Gemini API unavailable from EEA without billing
- Smarkets timeouts (read timeout=6)
- Telegram getUpdates timeouts (read timeout=8)

## Verified
- EVR-0002 PASS: nee + OmniRoute + VPS + Bootstrap

## Current Priority
- Stabilize BET-ANALYZER polling
- Fix Smarkets timeouts

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

## 2026-10-12 (evening)
- G-0014 closed: bonus_cron.py + systemd timer (61e24db, 757e6f3, 02c100f)
- Baseline: 293 passed, 2 deselected
- bonus-cron.timer: enabled, Linger=yes
- snapshot: data/bonuses_snapshot.json (33 bonuses), gitignored
- OmniRoute поднят вручную (autostart ломается headless)
