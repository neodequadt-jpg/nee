# EVR-0020-What-Was-Done: Audit of BET-ANALYZER since 2026-10-12

**Date:** 2026-10-12
**Object:** Full read-only audit of work done in BET-ANALYZER from 2026-10-12
**Author:** Audit agent (READ-ONLY, no code changes)

---

## Environment

- repo: ~/BET-ANALYZER, branch main, HEAD: 09a170a
- 30 commits on 2026-10-11/12 (29 on Oct 12, 1 on Oct 11)
- python 3.11.2, pytest 9.1.1
- branches: main, feat/g0013-bonus-tracker, feat/g0014-bonus-cron

---

## A) Closed Goals

| ID     | Title                                      | Commits                                                                                     | EVR                      | Status     |
|--------|--------------------------------------------|---------------------------------------------------------------------------------------------|--------------------------|------------|
| G-0011 | /stats command                             | c26fdbf                                                                                     | EVR-0012                 | COMPLETED  |
| G-0012 | Resolver + cmd_stats (footbolno wire)      | e8cdbb7 bfbd925 295d7e8 775e049 170b2c3                                                    | EVR-0013–0020            | COMPLETED  |
| G-0013 | Bonus track (monitor+tracker+matched+bookmaker) | ac429c9 7192390 503cb6a 212c157 6140948 aa2ffe0 1d20089                              | EVR-0021                 | COMPLETED  |

---

## B) Commits by Group

### Bonus track (7 commits)
| Hash   | Message |
|--------|---------|
| ac429c9 | feat(bonus-monitor): fetch + normalize + snapshot diff for metaratings |
| 7192390 | feat(bonus-tracker): manual registry with validate + auto-expire |
| 503cb6a | feat(matched-betting): SNR lay stake calc + optimal lay search |
| 212c157 | feat(bookmaker-monitor): registry + 0-100 reliability scoring |
| 6140948 | test(bonus): 31 unit tests for monitor + tracker |
| aa2ffe0 | test(bonus): 21 unit tests for matched_betting + bookmaker_monitor |
| 1d20089 | merge: G-0013 bonus track |

### Bot commands (5 commits)
| Hash   | Message |
|--------|---------|
| 934d634 | feat(bot): /bonuses, /lay, /bookmakers + inline buttons |
| 8700e85 | fix(bot): use own .venv instead of foreign AVITO venv |
| 85d5ae8 | feat(plan): one-tap matched betting plan builder |
| 09a170a | feat(bot): /plan and /plan_go — one-tap matched betting |
| c685203 | chore: ignore EVR-*.md (evidence lives in ~/NEE/logs/) |

### Resolver / footbolno (5 commits)
| Hash   | Message |
|--------|---------|
| e8cdbb7 | feat(providers): add footbolno.ru adapter |
| bfbd925 | fix(footbolno): in-memory cache respects TTL |
| 295d7e8 | test(footbolno): add 22 unit tests (mock session, no network) |
| 775e049 | feat(resolver): route RPL + Nations League through footbolno |
| 170b2c3 | test(cmd_stats): add 9 unit tests (tmp_path, no network) |

### Прочее (13 commits)
| Hash   | Message |
|--------|---------|
| 091aa84 | fix(stability): WG split-tunnel, static DNS, longer timeouts, valid token |
| a859c90 | refactor(smarkets): hoist now/lo/hi out of duplicate branches |
| 06b9c18 | test: split unit/integration; mark live pipeline tests @integration |
| 28ca63f | test(consensus): add 9 unit tests for implied_prob, remove_margin, consensus_from_subset |
| ab0f13b | test(consensus): add 7 mocked tests for build_consensus + evaluate_event |
| c60beba | test(consensus): add 3 tests for consensus_per_bookmaker + ConsensusOutcome |
| d7f687a | test(resolver): add 20 edge-case tests for normalize/parse/determine/find |
| c9a5f80 | chore: gitignore backups; refresh AGENTS.md context for DSH |
| df22fd2 | test(resolver): add 14 mocked network tests for _get_session + _fetch_events_for_date |
| 10ff450 | fix(tests): clear env in test_session_with_http_proxy |
| c26fdbf | feat: add /stats command (won/lost/ROI 7d) |
| 167f9a0 | docs: AGENTS.md — DSH write-access warning |
| 7add553 | chore: ignore NEE-logs symlink |

---

## C) Directory Structure

| Directory   | Files | Lines |
|-------------|-------|-------|
| providers/  | 2     | 354   |
| scoring/    | 10    | 1386  |
| scripts/    | 1     | 113   |
| tests/      | 22    | 3003  |

---

## D) Metrics

| Metric                | Value |
|-----------------------|-------|
| Baseline start        | 185 passed |
| Baseline current      | 277 passed |
| Delta                 | +92 tests |
| Deselected            | 2 (integration) |
| EVR range in logs     | EVR-0002 → EVR-0022 |
| EVR count in logs     | 20 files |

---

## E) Anomalies (facts only)

1. **providers/footbolno.py.bak** — backup file present in tree (should be gitignored; .gitignore has `*.bak` per c9a5f80 but file still present in working tree).

2. **chmod 0600** on 8 files:
   - scoring/resolver.py
   - tests/conftest.py
   - tests/test_ev_kelly.py
   - tests/test_ai_max_tokens.py
   - tests/test_synthetic_bk.py
   - tests/test_resolver_network.py
   - tests/test_tg_resilience.py
   - tests/test_resolver.py

3. **G-0014 ID conflict**:
   - CURRENT_GOAL.md defines G-0014 as "Bonus snapshot cron + Telegram alert"
   - EVR-0022-G0014-Bot-Commands.md labels the bot commands work (/bonuses, /lay, /bookmakers) as G-0014
   - Branch feat/g0014-bonus-cron exists (matches CURRENT_GOAL.md definition)
   - Same ID used for two different work items.

4. **EVR-0023 missing**: Commit 09a170a references "Evidence: EVR-0023" but EVR-0023 does not exist in ~/NEE/logs/.

5. **EVR pending**: Commit 85d5ae8 (plan_builder) says "Evidence: EVR (pending)" — no EVR number assigned.

6. **EVR-0020/0021 skip in commit flow**: EVR-0020 (CmdStats-Tests) and EVR-0021 (G0013-Bonus-Track) exist in ~/NEE/logs/ but are not referenced in any commit message. They were written as post-hoc evidence, not tied to specific commits.

---

## F) Unfinished G-0014 Steps (from CURRENT_GOAL.md)

CURRENT_GOAL.md G-0014 "Bonus snapshot cron + Telegram alert" steps:

| Step | Description | Status |
|------|-------------|--------|
| 1 | scripts/bonus_cron.py: fetch → diff vs snapshot → save → alert if new | **NOT DONE** — file does not exist |
| 2 | Alert via tg_bot.send_message (existing) | **NOT DONE** |
| 3 | Cron: systemd timer OR crontab (choose) | **NOT DONE** |
| 4 | Tests: cron logic (fetch/diff/save with mocks, no network) | **NOT DONE** |
| 5 | EVR-0022 | **MISMATCH** — EVR-0022 was used for bot commands, not cron |

**scripts/bonus_cron.py: DOES NOT EXIST**

---

## Expected

Audit report covering closed goals, commit grouping, directory structure, metrics, anomalies, and unfinished steps — all derived from specified read-only sources.

## Observed

All 6 data sources read successfully. 30 commits analyzed (all from 2026-10-11/12). 3 goals closed (G-0011, G-0012, G-0013). 6 anomalies identified. G-0014 (cron) has 0 of 5 steps completed. scripts/bonus_cron.py does not exist.

## Result

**PASS** — Audit complete. No code modified, no files created except this EVR artifact.
