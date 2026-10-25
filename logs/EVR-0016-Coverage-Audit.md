# EVR-0016: Coverage audit — signals vs footbolno.ru

Date: 2026-10-12
Author: G-0012 probe #3
Objective: Determine what % of 348 backtest signals resolves through footbolno.ru

## Methodology

1. Read all 120 signal files from data/backtest/signals/*.json → 348 signals
2. For each signal: extract league, home, away, kickoff (YYYY-MM-DD)
3. League routing:
   - RPL → footbolno data/league/235-matches.csv (season 2026/2027)
   - Nations League (A/B/C) → footbolno data/league/5-matches.csv (season 2026/2027)
4. Match by date + team names:
   - exact: home & away strings identical
   - case-insensitive: identical after .lower()
   - fuzzy: identical after normalization (ё→е, strip ФК prefix, collapse hyphens/spaces, lowercase)
5. Classify as matched_exact, matched_fuzzy (includes CI), or not_found

## Results

| Metric | Value |
|--------|-------|
| Total signals | 348 |
| Matched exact | 252 |
| Matched case-insensitive | 0 |
| Matched fuzzy (normalized) | 0 |
| Matched total | 252 |
| Not found | 96 |
| Coverage % | 72.4% |

### Breakdown by league

| League | Total | Exact | CI | Fuzzy | Not Found | Coverage |
|--------|-------|-------|----|-------|-----------|----------|
| RPL | 258 | 162 | 0 | 0 | 96 | 62.8% |
| Nations League A | 61 | 61 | 0 | 0 | 0 | 100.0% |
| Nations League B | 1 | 1 | 0 | 0 | 0 | 100.0% |
| Nations League C | 28 | 28 | 0 | 0 | 0 | 100.0% |

### Not-found analysis

All 96 not-found signals are the same match: Факел vs Локомотив Москва on 2026-10-10.
Root cause: footbolno names the team Локомотив, signal says Локомотив Москва.
City suffix Москва is not covered by specified normalization rules.
Nearest footbolno match on same date: Факел vs Локомотив.

### Projection with city-suffix normalization

| Metric | Without city norm | With city norm (projected) |
|--------|-------------------|---------------------------|
| Matched | 252 | 348 |
| Not found | 96 | 0 |
| Coverage | 72.4% | 100.0% |

## Answer

72.4% of 348 signals resolve through footbolno.ru under specified normalization.
With city-suffix normalization, coverage = 100%.
Nations League: 100% (90/90 exact). RPL: 62.8% → 100% projected.

## Verification records

| Object | Expected | Observed | Result |
|--------|----------|----------|--------|
| Total signal count | 348 | 348 | PASS |
| RPL footbolno data | > 0 | 240 matches | PASS |
| NL footbolno data | > 0 | 156 matches | PASS |
| NL A exact match | 61/61 | 61/61 | PASS |
| NL B exact match | 1/1 | 1/1 | PASS |
| NL C exact match | 28/28 | 28/28 | PASS |
| RPL not-found | match | Локомотив Москва ≠ Локомотив | FAIL (city suffix) |
| Overall coverage | high % | 252/348 = 72.4% | PARTIAL |
