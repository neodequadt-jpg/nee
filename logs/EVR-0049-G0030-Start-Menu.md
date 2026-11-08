# EVR-0049 — G-0030 add /start and /help to Telegram menu (PASS)

Object: tg_bot.py _set_bot_menu() commands list
Environment: jailLMDE, ~/BET-ANALYZER, HEAD 8d31b7f (base), commit daa37ae
Date: 2026-11-08

## Expected
- /start and /help appear in Telegram bot menu (getMyCommands)
- py_compile OK, pytest 319/7

## Observed
- EVR-0048 probe: /start in dispatch (2181, 2447), get_welcome_text 710 chars,
  bot polling, no webhook, but /start missing from getMyCommands (9 cmds)
- dshh+gpt-4o-mini first attempt: rewrote ENTIRE tg_bot.py (2582 lines)
  to a single line `START_COMMANDS = ["/start", "/help"]` + stray response.txt
  -> A36 (destructive-rewrite), recovered via `git checkout -- tg_bot.py`
- manual replace applied: 2 tuples at top of commands list

## Patch
OLD:
    commands = [
        ("value", "Value bets с EV"),
        ("signals", "Топ-5 сигналов + Kelly"),
NEW:
    commands = [
        ("start", "Начать заново / Start"),
        ("help", "Помощь / Help"),
        ("value", ...),
        ("signals", ...),

## Verification
py_compile OK
pytest -q -> 319 passed, 7 skipped, 2 deselected
git diff --stat -> 1 file, 2 insertions
commit -> daa37ae feat(bot): add /start and /help
getMyCommands (after restart): result[0]=start, result[1]=help,
  result[2]=value, result[3]=signals (confirmed in live Telegram API)

## Result
PASS.

## Note
A36: dshh is NOT suitable for patching existing large files. gpt-4o-mini
runs in generate-mode and rewrites the whole file. Use dshh ONLY for:
probe (read-only), new file (module template), EVR. For edits:
python3 replace with assert count==1, or `git apply`.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
