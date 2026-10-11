# CURRENT ENGINEERING GOAL

ID: G-0010
Title: Mock network in resolver.py

## G-0009: PARTIAL
- [x] _normalize, _parse_kickoff, _determine_result, _find_match (EVR-0010, 20 tests)
- [ ] _get_session — mock requests.Session
- [ ] _fetch_events_for_date — mock session.get
- [ ] resolve_all — mock _fetch_events_for_date + файловая система

## G-0010 Next
1. Тест _get_session: с HTTPS_PROXY env → session.proxies настроен
2. Тест _fetch_events_for_date: mock session.get → вернуть [events]
3. Тест _fetch_events_for_date: mock session.get → status 500 → []
4. Тест _fetch_events_for_date: mock session.get → exception → []
5. Тест resolve_all — опционально, требует tmp_path для signals/results

## Rules
- DSH halucinates — verify each claim
- py_compile after each patch
- One step = one commit
- unittest.mock для сети
