# EVR-0037 — G-0021 housekeeping: triage Tech debt + surface reduce (PASS)

Object: ~/NEE/BOOTSTRAP/CURRENT_GOAL.md (Tech debt), ~/.bet_env.bak.* (2 files)
Environment: jailLMDE, ~/NEE (HEAD 5c8b446), ~/.omniroute storage.sqlite
Date: 2026-10-26

## Expected
- Tech debt отражает факты 2026-10-26 (нет stale dshh/ALL_PROXY)
- deferred/accepted теги для G-0022/G-0019/orphan keys/EVR-0023
- бэкапы .bet_env удалены, рабочих ключей в них нет
- ~/.bet_env остаётся 600

## Observed (REALITY, шаг 1)
- api_keys: Bet_analyzer (active, last_used 2026-10-26T00:56),
  CLI Auto-Key (active, last_used NULL), bet-analyze (active, last_used 2026-10-12T16:44)
- Tech debt (5 строк): 2 stale (dshh, ALL_PROXY), 2 accepted-needed
  (orphan keys, EVR-0023), 1 real (autostart)
- .bet_env.bak.1791824522 (412 B, 10-12 20:02)
- .bet_env.bak.1791826822 (412 B, 10-12 20:40)
- safety check: both backups contains_current=0, contains_old_fallback=False
  (no working key, no dead sk-8445…)
- current OMNI key: 1 (len=35)
- критерий "grep -c dshh.*ротировать" = 0 был само-референсным:
  матчил строку Done when в G-0021, не stale Tech debt.
  Фактическая проверка: sed блока Tech debt (triaged) — 7 тегов, stale нет.

## Patch
- Tech debt replaced: 5 строк -> 7 тегов [open]/[accepted]/[deferred]/[resolved]
- .bet_env.bak.* removed (2 files, no current keys)
- ~/.bet_env untouched, 600

## Verification
sed -n '/^## Tech debt (triaged/,/^## /p' -> 7 tagged entries
grep -n "dshh.*ротировать" -> только line 13 (Done when в G-0021,
  само-референс; исчезает при закрытии G-0021)
ls ~/.bet_env.bak.* -> No such file
stat ~/.bet_env -> 600
git status -> M CURRENT_GOAL.md only

## Result
PASS.

## Note
- Orphan keys not revoked: /api/keys 401 (no admin key); manual via /dashboard.
  Marked [accepted] — not blocking.
- G-0022 (gemini 500) и G-0019 (DSH plugin) — deferred, не в этом scope.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- ARTEM-CORE п.4 (Bootstrap is the Only Source of Truth)
