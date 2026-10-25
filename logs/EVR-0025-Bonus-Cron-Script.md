# EVR-0025 — Bonus Cron Script

## Object
Implement `scripts/bonus_cron.py` — cron script for G-0014 (bonus snapshot → Telegram alert) with `tests/test_bonus_cron.py`. Only new files; existing modules unchanged.

## Environment
- Python 3.11.2, pytest 9.1.1
- Existing modules: `scoring/bonus_monitor.py` (fetch_bonuses, normalize, snapshot_diff, save_snapshot, load_snapshot), `tg_bot.py` (send_message, TG_ADMIN_IDS)
- Pattern reference: `scripts/fetch_injuries.py` (shebang, ROOT/sys.path.insert, logging→stderr, main()→int, sys.exit(main()))
- No python-dotenv; custom env parser for `~/.bet_env` (shell-style) and `.env.bot` (plain KEY=VALUE)

## Expected
1. `scripts/bonus_cron.py`:
   - Env loading from `~/.bet_env` then `.env.bot`; no overwrite of existing os.environ; log "env loaded from X (n vars)" without values
   - If TG_ADMIN_ID empty after env load → main() returns 2
   - Proxy env cleanup (HTTP_PROXY, HTTPS_PROXY, ALL_PROXY, http_proxy, https_proxy, all_proxy) before fetch_bonuses()
   - Pipeline: fetch_bonuses → normalize → load_snapshot → snapshot_diff → save_snapshot → alert
   - save_snapshot called BEFORE sending alerts
   - Alert format: HTML with 🎯 header, counts, up to 5 new items (bookmaker + title + url, html.escape)
   - CLI: --dry-run (no send, no save, print counts), --force (send even on empty diff), --verbose (DEBUG)
   - Structure: shebang, ROOT/sys.path.insert, logging→stderr, main()→int, sys.exit(main())
2. `tests/test_bonus_cron.py`: 8 test cases (a–h) covering all behaviors, no network
3. `py_compile` passes; all tests green

## Observed
- `python -m py_compile scripts/bonus_cron.py` → OK
- `pytest tests/test_bonus_cron.py -v` → **15 passed in 0.76s**:
  - TestAllNewSendsToAllAdmins::test_all_new_sends_to_all ✅
  - TestNoChangesNoSend::test_no_changes ✅
  - TestNewBonusSendsWithHTML::test_sends_with_html ✅
  - TestDryRunNoSendNoSave::test_dry_run ✅
  - TestForceSendsOnEmptyDiff::test_force_empty_diff ✅
  - TestFetchRaisesNonZero::test_fetch_raises ✅
  - TestProxyEnvClearedBeforeFetch::test_proxy_cleared ✅
  - TestEnvParser::test_export_prefix_stripped ✅
  - TestEnvParser::test_plain_key_value ✅
  - TestEnvParser::test_already_set_not_overwritten ✅
  - TestEnvParser::test_quotes_stripped ✅
  - TestEnvParser::test_comments_and_empty_lines_skipped ✅
  - TestFormatAlert::test_format_with_new_items ✅
  - TestFormatAlert::test_format_limits_to_five ✅
  - TestEmptyAdminIdReturns2::test_empty_admin_id ✅

## Result
✅ PASS — All requirements met. New files only, no modifications to existing modules. 15/15 tests green.
