# EVR-0030 — D-0001 Course Decision Committed

**Object:** BOOTSTRAP/DECISIONS.md, decision D-0001 (product-first, meta-frozen).
**Environment:** ~/NEE, branch main, 2026-10-25, LMDE. Docs only.
**Expected:** File exists, contains D-0001 with decision / rationale / alternatives / reversal / caveat. No secrets.

**Observed:**
- `ls -la BOOTSTRAP/DECISIONS.md` → `-rw-r--r-- 1 jail jail 1355 окт 25 23:36 BOOTSTRAP/DECISIONS.md`
- `wc -l` → `30 BOOTSTRAP/DECISIONS.md`
- `sed -n '1,80p'` → D-0001 present: Decision, Rationale, Alternatives (A/B/C), Reversal conditions, Status, Caveat.
- `rg -n -i 'api[_-]?key|token|secret|password|OMNIROUTE'` → no matches (exit 1, "clean").

**Result:** PASS

**Notes:**
- Decision is hypothesis, not fact (see D-0001 "Caveat").
- Reversal review date: 2027-04-25.
- CURRENT_GOAL update is separate step (EVR-0031), not bundled here.