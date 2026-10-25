# EVR-0022: G-0014 bot commands — /bonuses, /lay, /bookmakers

**Date:** 2026-10-12
**Object:** tg_bot.py — three new commands + inline buttons
**Status:** PASS

## Environment
- repo: ~/BET-ANALYZER, branch: main, HEAD before: 8700e85
- baseline before: 268 passed, 2 deselected

## Expected
Add commands wired to scoring modules, inline keyboard buttons, callback handlers.
No new dependencies. Baseline preserved.

## Observed

### tg_bot.py changes (5 patches, deterministic script)
1. cmd_bonuses(chat_id): reads list_active() from scoring.bonus_tracker
2. cmd_lay(text): parses "/lay <freebet> <back> <lay> [comm]", calls calc_lay
3. cmd_bookmakers(chat_id): list_recommended/list_risky from scoring.bookmaker_monitor
4. dispatch(): three new branches after /stats
5. get_welcome_text(): three new help lines
6. get_main_keyboard(): new row [Bonuses | Lay calc | BMs]
7. _handle_callback(): handles "bonuses", "lay_help", "bookmakers"

### Smoke
cmd_bonuses(0):
  🎁 Bonuses — 2 активных
  • Winline: 10000₽ (freebet_snr) кэф 1.3–2.5, до 2026-12-31
  • PARI: 15000₽ (freebet_snr) кэф 1.5–3.0, до 2026-12-31

cmd_lay("/lay 10000 2.0 2.05"):
  Lay stake: 4926.11₽ | Liability: 5172.41₽ | Guaranteed: +4827.59₽

cmd_bookmakers(0):
  Рекомендуемые (≥70): Winline 87, PARI 87, Fonbet 84, ...
  Рискованные (<50): Cosmobet 15, 1xBet 24, BetCity 24, Mostbet 34, Leon 40

### Baseline
- before: 268 passed, 2 deselected
- after:  268 passed, 2 deselected (no regressions)

## Result: PASS

## Notes
- /lay accepts inline args (text after command). No need for _LAST_LAY_ARGV global.
- callback "lay_help" shows usage without args.
- dshh not used — patch applied via deterministic python script (dsh PI_AI_ERROR
  pattern made it unreliable for this task).
