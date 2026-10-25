# EVR-0017: Footbolno provider — adapter + TTL fix + tests

**Date:** 2026-10-12
**Object:** providers/footbolno.py + tests/test_footbolno_provider.py
**Status:** PASS

## Environment

- repo: ~/BET-ANALYZER, branch main
- python 3.11.2, venv, requests 2.32.5 (no httpx)
- baseline before: 185 passed, 2 deselected
- egress: direct (45.11.24.103), env http_proxy=:8118 DEAD, VPS SOCKS5 :1080 blocks footbolno

## Expected

1. Provider fetches footbolno.ru leagues 235 (RPL) and 5 (Nations League).
2. Match by canonical (home_id, away_id, date_utc[:10]) — not by names.
3. Name→id resolution: exact / CI / normalized / city-suffix strip (unambiguous only).
4. UTF-8 encoding forced (server sends no charset).
5. Cache TTL enforced in-memory AND on-disk.
6. Unit tests via mock session, no network.
7. Baseline preserved.

## Observed

### Commit 1: e8cdbb7 — feat(providers): add footbolno.ru adapter
- +354 lines: providers/__init__.py, providers/footbolno.py, .gitignore
- fetch_league(235) → 2580 matches, fetch_league(5) → 820 matches
- golden cases verified end-to-end (real network):
  - Ростов vs Акрон @ 2026-10-09 → Match(1:0, espn:3852/espn:22271)
  - Словакия vs Молдова @ 2026-09-26 → Match(2:0)
  - Исландия vs Эстония @ 2026-09-26 → Match(1:1)
  - Факел vs Локомотив Москва @ 2026-10-10 → Match (fuzzy, away_id=espn:442)
  - Динамо vs Краснодар @ 2026-10-01 → None (ambiguous, two Dinamo)
- coverage audit: 348/348 = 100.0% of backtest signals resolved
  (baseline EVR-0016 said 72.4% with naive norm; city-suffix strip closed the gap)

### Commit 2: bfbd925 — fix(footbolno): in-memory cache respects TTL
- BUG: fetch_league returned stale in-memory hit indefinitely
  (bypassed disk TTL in _read_cache). Affects long-lived tg_bot.py.
- FIX: _inmem_ts dict, check (now - ts) <= ttl before returning.

### Commit 3: 295d7e8 — test(footbolno): add 22 unit tests
- test_footbolno_provider.py, 240 lines
- all mock-based, no network
- 22 passed

### Baseline

- before: 185 passed, 2 deselected
- after: 207 passed, 2 deselected
- delta: +22 (new tests), zero regressions

## Result: PASS

## Notes / open

- dsh failed 3× with PI_AI_ERROR on this task (research-heavy prompts).
  Workaround: tests written manually. Pretheory candidate.
- EVR written manually because dsh cannot write to ~/NEE/logs/
  (sandbox read-only outside workspace). Pretheory candidate.
