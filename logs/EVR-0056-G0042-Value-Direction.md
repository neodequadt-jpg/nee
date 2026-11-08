# EVR-0056 — G-0042 reverse value direction: Shin Pinnacle, Fonbet value (PASS)

Object: scoring/ev.py, scoring/devig.py
Environment: jailLMDE, ~/BET-ANALYZER, HEAD 4bccb6e (base)
Date: 2026-11-09

## Expected
- true_prob = devig(sharp=Pinnacle); value candidate = soft=Fonbet
- synthetic: value @ Fonbet, not Pinnacle
- pytest 319/7, cmd_value (real) может быть 0

## Observed (before)
- evaluate_value: per_bk[Pinnacle] = Fonbet-only fair (0.0866)
- draw Бавария-Кёльн @ Pinnacle 13.09 → EV+13.4% = арбитраж (A40)
- false value — пользователь ставит против sharp мнения

## Patch
1. New scoring/devig.py:
   - shin_devig(odds): binary search z in (0,1) на sum(pi(z))=1
   - multiplicative_devig(odds): fallback (Q<=1.0)
2. scoring/ev.py evaluate_value rewritten:
   - SHARP_BOOKS = {Pinnacle, Betfair}
   - fair = shin_devig(sharp_odds) или consensus fallback
   - value candidate: bk not in SHARP_BOOKS, bk_odds > 1/fair
   - unknown bookmaker (Fonbet not in registry) -> trust=0.5, not skip
   - known bookmaker trust < MIN_TRUST -> skip

## Verification
shin_devig unit tests (manual):
  [1.8,3.5,4.5]: shin=[.531,.266,.203] mult=[.522,.269,.209] diff fav=+0.9%, ls=-0.6%
  [1.3,5.5,8.0]: shin=[.736,.160,.104] mult=[.715,.169,.116] diff fav=+2.2%, ls=-1.2%
  [1.5,4.0,7.0]: fair=[1.557,4.319,7.924]
synthetic: draw @ Fonbet odds=4.5 fair=4.32 EV+4.2% PASS
py_compile OK
pytest -q -> 319 passed, 7 skipped, 2 deselected
cmd_value real -> 215 matches, 0 value bets (Fonbet follows Pinnacle on top-5)

## Result
PASS.

## Note
Old 2 value_bets были артефактом арбитража (Pinnacle vs Fonbet-fair).
Real value появится когда:
- Fonbet misprices RPL: нет soccer_russia_premier_league в Pinnacle keys -> G-0045
- Betfair/odds-api.io добавлены как второй sharp -> G-0043
Fonbet не в registry: trust=0.5 -> deal_score низкий (26 в synthetic), но не skip.
Add Fonbet to registry (trust=0.75+) — G-0046.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- PRETHEORY A40 (value в sharp = арбитраж) — fixed
