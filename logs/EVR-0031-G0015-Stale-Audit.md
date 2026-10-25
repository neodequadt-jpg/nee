# EVR-0031 — G-0015 Stale Audit + BET-ANALYZER tree state

Object: цель G-0015 (Wire /bonuses) и рабочее дерево BET-ANALYZER
Environment: jailLMDE, /home/jail/BET-ANALYZER, branch main, HEAD ab0eab9
Date: 2026-10-26

## Expected
- G-0015 — кандидат (не реализован)
- рабочее дерево чистое
- baseline 293 passed (по ~/NEE/BOOTSTRAP/STATE.md)
- OMNI_KEY/OMNIROUTE_API_KEY валидны для OmniRoute

## Observed
- G-0015 УЖЕ реализован в ab0eab9:
    tg_bot.py:2012  def cmd_bonuses
    tg_bot.py:2147  if command == "/bonuses"
    tg_bot.py:2201  if data == "bonuses"
    tg_bot.py:292   кнопка "Bonuses" (RU)
    tg_bot.py:319   кнопка "Bonuses" (EN)
    tg_bot.py:348   welcome-строка /bonuses
    tg_bot.py:1537/1547/2425 — help/commands
  ~/NEE/BOOTSTRAP/CURRENT_GOAL.md устарел (G-0015 как candidate)
- baseline: 318 passed, 8 skipped, 2 deselected (не 293)
- dirty tree: 4 файла M (+5/-5):
    ai/analyst.py, ai/client.py, ai/express_builder.py, tg_bot.py
- P1: ai/{analyst,client,express_builder}.py содержат fallback
    "sk-84454d30f22bfcb1-5d2256-72fbd6b3" (rotated 2026-10-12)
- bug: tg_bot.py:92-93 OMNI_CHAT_MODEL_FREE == OMNI_CHAT_MODEL
    == "dva/claude-opus-5-high" (free-тир пойдёт по премиум-цене)
- OmniRoute v16 жив: 127.0.0.1:20128, pid 2817
- auth: OmniRoute принимает только Authorization: Bearer
    OMNI_KEY        / bearer -> HTTP 401 "Invalid API key"
    OMNI_KEY        / x-api-key -> HTTP 401 "Authentication required"
    OMNIROUTE_API_KEY / bearer -> HTTP 401 "Invalid API key"
    OMNIROUTE_API_KEY / x-api-key -> HTTP 401 "Authentication required"
  Вывод: схема распознана, оба ключа в ~/.bet_env не валидны.
  Валидация включена после 2026-10-12, .bet_env не синхронизирован.

## Result
PASS (аудит).

G-0015 закрывается как already-done, не как новая работа.
Bootstrap ~/NEE/BOOTSTRAP/ устарел -> отдельная цель (G-0018).
dirty tree содержит P1 и bug -> блокер для следующего шага.

## Next
- Шаг A: P1 — убрать hardcoded OMNI_KEY fallback в ai/* (не зависит от auth)
- Шаг B: bug — вернуть отдельный OMNI_CHAT_MODEL_FREE (не зависит от auth)
- auth: валидный клиентский ключ OmniRoute -> отдельная цель G-0017
- Шаг C (ai/* -> gpt-4o-mini) заблокирован до валидного ключа

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- CONSTRAINTS: Never Commit Secrets (P1)
- PRETHEORY A9 (git status ДО и ПОСЛЕ)
