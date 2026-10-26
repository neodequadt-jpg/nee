# CURRENT ENGINEERING GOAL

No active goal.

## Recently closed
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

## Tech debt
- OmniRoute: 2 orphan active keys (bet-analyze, CLI Auto-Key) — отозвать
- EVR-0023 отсутствует (commit 09a170a ссылается)
- OmniRoute не поднимается при boot (autostart ломается при headless)
- OMNIROUTE_API_KEY засвечен в ~/NEE/bin/dshh → ротировать, вынести в ~/.bet_env
- ALL_PROXY=socks://45.11.24.103:1080 в env — VPS SOCKS не отвечает, рудимент
