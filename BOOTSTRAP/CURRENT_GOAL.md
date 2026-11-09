# CURRENT ENGINEERING GOAL

No active goal.

## Recently closed
- G-0042: reverse value direction (Shin Pinnacle, Fonbet value) — 2026-11-09 (EVR-0056)
  - scoring/devig.py: shin_devig + multiplicative fallback
  - evaluate_value: fair=Shin(Pinnacle), value candidate=Fonbet
  - synthetic PASS: draw@Fonbet 4.5 fair 4.32 EV+4.2%
  - real 215 matches 0 value (Fonbet follows Pinnacle on top-5; correct)
- G-0040: RU→EN aliases top-5 + Ligue 1 key — 2026-11-09 (EVR-0055)
  - 96 aliases (EPL/La Liga/Serie A/Bundesliga/Ligue 1)
  - +soccer_france_ligue_one Pinnacle key
  - France 9/9 sources=2; cmd_value 195 matches, 2 value bets
- G-0039: expand Fonbet window 48h→168h, cap 10→50 — 2026-11-08 (EVR-0053) [PARTIAL]
  - fonbet today 30→150, total events 113→217
  - EPL/La Liga/Serie A still sources=1 (RU≠EN names, need G-0040)
- G-0034: raise Pinnacle ttl 300→900 — 2026-11-08 (EVR-0052)
  - 7 keys: 84 req/hour -> 28 req/hour (3× less quota burn)
  - x-requests-remaining 384, quota would exhaust in <1 day at ttl=300
- G-0031: parse F_DRAW in fetch_real_today — 2026-11-08 (EVR-0050)
  - draw consensus now possible for all football (non-RPL too)
  - 0 new HTTP calls; 319/7; 2 files +3/-2
- G-0030: /start + /help in Telegram menu — 2026-11-08 (EVR-0049)
  - 2 tuples added to _set_bot_menu commands list
  - A36: dshh+gpt-4o-mini rewrote whole file, recovered via git checkout
- G-0029: STATE.md sync — 2026-11-08 (EVR-0047)
  - HEAD -> 8d31b7f, +G-0028, +_sanitize_error in 2026-11-08
  - A35: close-скрипт должен включать STATE.md sync
- G-0028: _sanitize_error coverage — 2026-11-08 (EVR-0046)
  - 4 log calls wrapped: 1960, 2489 (P2), 2547, 2550
  - dsh-orch.sh probe: dshh returned reasoning (A4), fix manual
- G-0027: STATE.md sync — 2026-11-08 (EVR-0045)
  - HEAD -> 592c79b, +G-0020..G-0026, 2026-11-08 block
- G-0026: isolate resolver test + dummy OMNI_KEY — 2026-11-08 (EVR-0044)
  - test_resolve_all_shape: empty tempdir, no footbolno timeout
  - conftest: sk-test-dummy OMNI_KEY at EOF (EVR-0032 side-effect)
- G-0025: automate daily signals — 2026-11-08 (EVR-0043)
  - generate-signals.sh + cron 11:00 MSK
  - text fixed (Smarkets -> Pinnacle)
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
- G-0043: add Betfair/odds-api.io as second sharp (value source, not just Fonbet follow)
- G-0045: add soccer_russia_premier_league Pinnacle key (RPL value source)
- G-0046: add Fonbet to registry with trust_score=0.75 (currently trust=0.5, deal_score низкий)
- G-0015: closed (already-done in ab0eab9) — see EVR-0031
- G-0016: API-Football fallback для resolver (нужен free key)

## Tech debt (triaged 2026-10-26)
- [open] A35 (×4: G-0027/0029/0030/0042): close-script does not auto-sync STATE.md; G-0035 close-g.sh should fix
- [resolved] A40: evaluate_value value in sharp = arbitrage; fixed in G-0042 (EVR-0056: Shin Pinnacle fair, Fonbet value)
- [accepted] A37: dshh sandbox has no .venv/bookmakers.* — python probes only local, dshh only grep/read/new-file
- [accepted] A18: restart bet-edge-bot after tg_bot.py edits (A18 confirmed ×2 this session)
- [accepted] dshh+gpt-4o-mini rewrote tg_bot.py (A36, 2026-11-08), recovered via git checkout; dshh restricted to probe/new-file/EVR only
- [accepted] OMNIROUTE_API_KEY in d213654:.env history sha256 19dd3f2db040 — rotated, not exploitable
- [accepted] ~/NEE/.env leaked OMNIROUTE_API_KEY sha256 fd7412672e33 (2026-11-08 chat) — tested 401, dead; file removed
- [accepted] dsh-orch.sh: 4 minor bugs (manage_hints unvalidated, show_history empty, git add unquoted, echo -e) — low risk, not blocking (P1+P2 fixed in 6ad57fb)
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
