# EVR-0014: football-data.org Free Tier — Reality-Check Probe

**Date:** 2026-10-12  
**Probe:** G-0012 resolver — does the free tier cover signal leagues?

---

## Environment

- API: `https://api.football-data.org/v4`
- Auth: X-Auth-Token (key read from .env, **not logged**)
- Client filter returned: `ilja` (free tier)
- Total competitions available: **13**

---

## 1. Free-Tier Competitions

| Code | Name | Plan |
|------|------|------|
| BSA  | Campeonato Brasileiro Série A | TIER_ONE |
| ELC  | Championship | TIER_ONE |
| PL   | Premier League | TIER_ONE |
| CL   | UEFA Champions League | TIER_ONE |
| EC   | European Championship | TIER_ONE |
| FL1  | Ligue 1 | TIER_ONE |
| BL1  | Bundesliga | TIER_ONE |
| SA   | Serie A | TIER_ONE |
| DED  | Eredivisie | TIER_ONE |
| PPL  | Primeira Liga | TIER_ONE |
| CLI  | Copa Libertadores | TIER_FOUR |
| PD   | Primera Division | TIER_ONE |
| WC   | FIFA World Cup | TIER_ONE |

### RPL / Nations League / Qualifiers — Availability

| Competition | Status | Detail |
|-------------|--------|--------|
| RPL (Russian Premier League) | **NOT AVAILABLE** | `GET /v4/competitions/RL` → 404; `RPL`, `RUS` codes → 404. Not in API at all. |
| UEFA Nations League | **RESTRICTED** | `GET /v4/competitions/UNL` → 403 "resource restricted, check your subscription". Exists but requires paid tier. |
| WC Qualifiers | **NOT AVAILABLE** | No qualifier competition in free-tier list. |
| EC Qualifiers | **NOT AVAILABLE** | No qualifier competition in free-tier list. |

---

## 2. Signal Match Probes

Selected 5 signals from `data/backtest/signals/`:

### Signal 1: Словакия vs Молдова
- **League:** UEFA Nations League C
- **Kickoff:** 2026-09-26 21:45 UTC
- **Probe:** `GET /v4/matches?dateFrom=2026-09-26&dateTo=2026-09-27`
- **Result:** 0 matches returned
- **Verdict:** **NOT FOUND** — Nations League not on free tier

### Signal 2: Исландия vs Эстония
- **League:** UEFA Nations League C
- **Kickoff:** 2026-09-26 19:00 UTC
- **Probe:** same date range as Signal 1
- **Result:** 0 matches returned
- **Verdict:** **NOT FOUND** — Nations League not on free tier

### Signal 3: Ростов vs Акрон
- **League:** RPL
- **Kickoff:** 2026-10-09 19:30 UTC
- **Probe:** `GET /v4/matches?dateFrom=2026-10-09&dateTo=2026-10-10`
- **Result:** 9 matches returned — all from BSA/PPL/DED/BL1/FL1/ELC/PD (no RPL)
- **Verdict:** **NOT FOUND** — RPL not in API (404)

### Signal 4: Дания vs Уэльс
- **League:** UEFA Nations League A
- **Kickoff:** 2026-09-27 19:00 UTC
- **Probe:** `GET /v4/matches?dateFrom=2026-09-25&dateTo=2026-09-27`
- **Result:** 0 matches returned
- **Verdict:** **NOT FOUND** — Nations League not on free tier

### Signal 5: Польша vs Босния и Герцеговина
- **League:** UEFA Nations League B
- **Kickoff:** 2026-09-25 21:45 UTC
- **Probe:** `GET /v4/matches?dateFrom=2026-09-25&dateTo=2026-09-25`
- **Result:** 0 matches returned
- **Verdict:** **NOT FOUND** — Nations League not on free tier

---

## 3. EVR Summary Table

| Object | Environment | Expected | Observed | Result |
|--------|-------------|----------|----------|--------|
| /v4/competitions (free tier) | football-data.org free | RPL + Nations League in list | 13 comps: top-5 leagues + CL/EC/WC/CLI, no RPL, no NL | **FAIL** |
| RPL competition code | /v4/competitions/RL, RPL, RUS | 200 + competition data | 404 Not Found | **FAIL** |
| Nations League competition | /v4/competitions/UNL | 200 + competition data | 403 Restricted | **FAIL** |
| Словакия vs Молдова (NL-C) | /v4/matches 26-27 Sep | Match found | 0 matches | **FAIL** |
| Исландия vs Эстония (NL-C) | /v4/matches 26-27 Sep | Match found | 0 matches | **FAIL** |
| Ростов vs Акрон (RPL) | /v4/matches 09-10 Oct | Match found | 9 matches, none RPL | **FAIL** |
| Дания vs Уэльс (NL-A) | /v4/matches 25-27 Sep | Match found | 0 matches | **FAIL** |
| Польша vs Босния (NL-B) | /v4/matches 25 Sep | Match found | 0 matches | **FAIL** |
| Free-tier general /v4/matches | date ranges with NL/RPL | Returns all matches | Returns only free-tier comp matches | **PARTIAL** |

---

## 4. Verdict

### **FAIL** — Free tier does NOT cover signal leagues

**Uncovered competitions:**
- **RPL** (Russian Premier League) — not in API at all (404)
- **UEFA Nations League A/B/C** — exists but restricted to paid tier (403)
- **WC/EC Qualifiers** — not available

**Implication for G-0012 resolver:**  
The football-data.org free tier cannot resolve results for **any** of the signal leagues in `data/backtest/signals/`. All signals are either RPL or Nations League. A paid subscription (TIER_TWO or higher) is required, or an alternative data source must be used for these leagues.

**Free-tier coverage:** Only top-5 European domestic leagues (PL, BL1, FL1, SA, PD), Championship, Eredivisie, Primeira Liga, BSA, plus CL/EC/WC/CLI cups.
