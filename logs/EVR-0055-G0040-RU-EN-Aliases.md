# EVR-0055 — G-0040 RU→EN aliases top-5 + Ligue 1 key (PASS)

Object: bookmakers/normalizer.py, bookmakers/team_aliases_en.py, tg_bot.py
Environment: jailLMDE, ~/BET-ANALYZER, HEAD 8c54d83 (base)
Date: 2026-11-09

## Expected
- Fonbet (RU) and Pinnacle (EN) merge for top-5 leagues
- sources=2 in consensus for EPL/La Liga/Serie A/Bundesliga/Ligue 1
- pytest 319/7
- value bets > 0 in cmd_value

## Observed (before)
- G-0039 PARTIAL: 196 matches, EPL/La Liga/Serie A sources=1
  (Fonbet RU 'Манчестер Сити' != Pinnacle EN 'Manchester City')
- Ligue 1 missing entirely: no soccer_france_ligue_one key
- 96 RU names from Fonbet (EVR-0053), 96 EN names from Pinnacle (EVR-0055 probe)

## Patch
1. New: bookmakers/team_aliases_en.py — RU_TO_EN 96 entries
2. normalizer.py:
   - import unicodedata + RU_TO_EN
   - _strip_diacritics() (Atlético/Köln/Alavés)
   - normalize_team: RU_TO_EN -> TEAM_ALIASES (chain Monaco works)
3. tg_bot.py: + soccer_france_ligue_one fetch + sum

## Verification
py_compile OK
pytest -q -> 319 passed, 7 skipped, 2 deselected
git diff --stat -> normalizer.py +11, tg_bot.py +3/-1, team_aliases_en.py new
normalize_team: 12/12 PASS (RU/EN/diacritics/Monaco/PSG/Paris FC)
build_pipeline: France 9/9 sources=[2,2,2]; pinnacle 67->76 events
cmd_value: 195 matches, 2 value bets (FIRST non-zero in this session)

## Result
PASS.

## Note
Diacritics needed: Pinnacle returns 'Atlético', 'Köln', 'Alavés';
Python lower() does NOT strip accents, so NFD normalize required.
TEAM_ALIASES chain ('as monaco' -> 'monaco') is why two-step lookup
(RU_TO_EN then TEAM_ALIASES) matters.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- PRETHEORY D3 (match by ID) — this is stopgap; long-term cross-provider
  ID mapping more robust than name aliases.
