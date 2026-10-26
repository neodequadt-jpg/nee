# CURRENT ENGINEERING GOAL

No active goal.

## Recently closed
- G-0022: stats window fix — 2026-10-26 (EVR-0040)
  - cmd_stats filters by kickoff (ISO or DD.MM HH:MM), preserves _resolved_at
  - resolver no longer overwrites _resolved_at on re-runs
- G-0021: housekeeping — 2026-10-26 (EVR-0037)
  - Tech debt triaged (7 tags); 2 stale entries removed
  - ~/.bet_env.bak.* removed (no current keys)
- G-0020: ai/* model swap — 2026-10-26 (EVR-0036)
  - gemini/… (500) -> openrouter/openai/gpt-4o-mini (200, json_object OK)
- G-0018: STATE.md sync — 2026-10-26 (EVR-0035)
  - baseline 293 -> 319/7, LLM block, Verified 0031..0034
- G-0017: OmniRoute auth — 2026-10-26
  - Key: Bet_analyzer (0ba95930…), plaintext в api_keys
  - Evidence: EVR-0034 (HTTP 200, count=1132, bet-edge-* PRESENT)
- G-0014: Bonus snapshot cron + Telegram alert — 2026-10-12
  - Commits: 61e24db, 757e6f3, 02c100f
  - Timer: bonus-cron.timer (00/06/12/18:05 MSK, Linger=yes)
  - Baseline: 277 → 293 passed
  - Evidence: EVR-0025, EVR-0026

## Candidates
- G-0015: closed (already-done in ab0eab9) — see EVR-0031
- G-0016: API-Football fallback для resolver (нужен free key)

## Tech debt (triaged 2026-10-26)
- [open] dashboard password weak, bound to 127.0.0.1; rotate via reset-password (getpass)
- [accepted] ~/.codex-home-from-BET-ANALYZER-20261026 (115M) retains dead-key transcript; delete after review
- [resolved] P1 OMNI_KEY leak in .codex-home transcript (15 oct) — rotated 2026-10-26, EVR-0038
- [open] OmniRoute autostart fails headless (systemd/supervisor) — real debt
- [resolved] OmniRoute orphan keys (bet-analyze, CLI Auto-Key, old Bet_analyzer) revoked 2026-10-26 (EVR-0038); only Bet_analyzer-2026-10-26b active
- [accepted] EVR-0023 lost (commit 09a170a references) — not reconstructable
- [accepted] ALL_PROXY=socks://45.11.24.103:1080 in env — dead, harmless
  (clients use trust_env=False)
- [deferred] gemini/gemini-3.1-flash-lite-preview 500 in OmniRoute — G-0022
  (ai/* on gpt-4o-mini, not blocking)
- [deferred] DSH plugin EVR-0002 PARTIAL — G-0019 (separate track)
- [resolved] dshh reads OMNIROUTE_API_KEY from ~/.bet_env (was hardcoded) —
  EVR-0001/0002
