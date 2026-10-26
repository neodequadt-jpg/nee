# EVR-0036 — G-0020 swap ai/* model to working id (PASS)

Object: ai/{analyst,client,express_builder}.py DEFAULT_MODEL/MODEL
Environment: jailLMDE, ~/BET-ANALYZER, branch main, base 0bcad9f
Date: 2026-10-26

## Expected
- модель в ai/* отвечает 200 и соблюдает response_format=json_object
- py_compile OK, pytest baseline 319/7 не сдвигается
- diff: 3 файла, 3/3

## Observed (chat completions via OmniRoute, max_tokens=64)
- gemini/gemini-3.1-flash-lite-preview -> HTTP 500, non-JSON (broken)
- openrouter/openai/gpt-4o-mini        -> HTTP 200, finish=stop, content_len=33
- bet-edge-primary                     -> HTTP 200, finish=tool_calls (риск для json)
- bet-edge-free                        -> HTTP 200, finish=stop, content_len=82
- max_tokens=1 ломает reasoning-модели (diagnostics: reasoning consumed 1/1)
- smoke json_object: openrouter/openai/gpt-4o-mini -> HTTP 200,
  finish=stop, content={"ok": true}, json.loads: OK

## Patch
OLD = "gemini/gemini-3.1-flash-lite-preview"
NEW = "openrouter/openai/gpt-4o-mini"
3 файла, assert count==1 в каждом.

## Verification
py_compile exit=0
pytest -q -> 319 passed, 7 skipped, 2 deselected
git diff --stat -> 3 files changed, 3 insertions(+), 3 deletions(-)
grep DEFAULT_MODEL/MODEL -> все три = openrouter/openai/gpt-4o-mini
grep "gemini/gemini-3.1-flash-lite-preview" ai/ -> OK: no gemini model
commit -> 93721a9 chore(ai): swap default model

## Result
PASS.

## Note
gemini/* 500 в OmniRoute не чинится — отдельная цель G-0022.
tg_bot.py уже использует bet-edge-* (EVR-0033), не тронут.
max_tokens=1 даёт ложные 502 на reasoning-моделях — учитывать в тестах.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
