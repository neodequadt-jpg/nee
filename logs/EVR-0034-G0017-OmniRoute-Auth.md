# EVR-0034 — G-0017 OmniRoute auth (PASS)

Object: валидный клиентский ключ OmniRoute для BET-ANALYZER
Environment: jailLMDE, ~/.omniroute (v16, pid 2817), ~/.bet_env
Date: 2026-10-26

## Expected
- GET /v1/models с валидным ключом -> HTTP 200
- bet-edge-primary и bet-edge-free в списке
- ключ только в ~/.bet_env (600), не в git

## Observed
- REQUIRE_API_KEY=false в .env и в environ pid 2817
  (процесс стартовал 25 окт 18:09, .env изменён 24 окт 10:23 — актуальный)
- но /v1/models с ключом из .bet_env -> 401 "Invalid API key"
  и без ключа -> 401 "Authentication required"
  => REQUIRE_API_KEY управляет /api/* (admin), не /v1/*
- api_keys (3 шт., все is_active=1, revoked_at=NULL,
  key_len=35, key_prefix=sk-84454d30f):
    Bet_analyzer  0ba95930…  last_used 2026-10-24T22:28
    bet-analyze   66f5288d…  last_used 2026-10-12T16:44
    CLI Auto-Key  7c2532ec…  last_used NULL
- .bet_env: OMNI_KEY и OMNIROUTE_API_KEY (35 симв.) не совпадали
  ни с key, ни с sha256(key_hash) ни одного из трёх
  => .bet_env устарел (12 окт), не синхронизирован после 24 окт
- sha256(fallback "sk-8445…") != key_hash ни одного ключа
  => fallback, удалённый в 0bcad9f, в БД отсутствовал; не скомпрометирован
- Bet_analyzer.key (plaintext в api_keys) записан в ~/.bet_env:
  OMNI_KEY=..., OMNIROUTE_API_KEY=...
- chmod 600 ~/.bet_env ~/.omniroute/.env (последний был 644)

## Verification
set -a; . ~/.bet_env; set +a
curl -H "Authorization: Bearer $OMNI_KEY" http://127.0.0.1:20128/v1/models

HTTP 200
count: 1132
bet-edge-primary PRESENT
bet-edge-free PRESENT

## Result
PASS.

## Note
bet-analyze и CLI Auto-Key — активные, но не используются, orphan.
Отзыв — housekeeping для G-0018, не блокер.
Шаг C (ai/* -> gpt-4o-mini) разблокирован, но требует проверки
наличия openai/gpt-4o-mini в списке 1132 моделей.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- CONSTRAINTS: Never Commit Secrets
