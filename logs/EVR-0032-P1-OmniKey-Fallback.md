# EVR-0032 — P1: drop hardcoded OMNI_KEY fallback in ai/*

Object: hardcoded fallback "sk-84454d30f22bfcb1-5d2256-72fbd6b3" в
        ai/{analyst,client,express_builder}.py
Environment: jailLMDE, /home/jail/BET-ANALYZER, branch main, base ab0eab9
Date: 2026-10-26

## Expected
- grep по ai/ не находит hardcoded ключ
- py_compile OK
- pytest baseline не сдвигается
- diff: 3 файла, замена одной строки на три (strict env-only, fail-fast)

## Observed
- patch: 3 файла, +9/-3, assert count==1 прошёл во всех
- py_compile exit=0
- pytest на чистом ab0eab9: 319 passed, 7 skipped, 2 deselected
- pytest с P1 patch:             319 passed, 7 skipped, 2 deselected
  (baseline не сдвинулся)
- grep "sk-84454d30f22bfcb1" ai/ -> пусто
- commit: 0bcad9f "security: drop hardcoded OMNI_KEY fallback in ai/* (P1)"
- исходный baseline 318/8 из EVR-0031 — dirty-tree, недействителен

## Result
PASS.

## Note
318/8 (EVR-0031) измерен с незакоммиченными model swaps в рабочем дереве.
Истинный baseline ab0eab9 = 319/7. В EVR-0031 это уточнение, не ошибка аудита.

## Rule refs
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- CONSTRAINTS: Never Commit Secrets (P1)
- PRETHEORY A7 (верификация после каждого шага)
