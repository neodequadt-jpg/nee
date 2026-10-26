# EVR-0033 — reject unverified model swap in tg_bot.py (no commit)

Object: tg_bot.py OMNI_CHAT_MODEL / OMNI_CHAT_MODEL_FREE
Environment: jailLMDE, /home/jail/BET-ANALYZER, branch main, HEAD 0bcad9f
Date: 2026-10-26

## Expected
- HEAD содержит раздельные модели: bet-edge-primary / bet-edge-free
- рабочее дерево и индекс совпадают с HEAD
- невалидные dva/claude-opus-5-high не попадают в историю

## Observed
- ab0eab9 и HEAD 0bcad9f: OMNI_CHAT_MODEL="bet-edge-primary",
  OMNI_CHAT_MODEL_FREE="bet-edge-free"
- stash@{0} содержал обе = "dva/claude-opus-5-high"
- git checkout stash@{0} -- tg_bot.py положил dirty-версию в index+worktree
- git diff --cached: HEAD bet-edge-* -> index dva/...
- dva/claude-opus-5-high не валиден в OmniRoute (EVR-0031: 401)
- действие: git restore --staged tg_bot.py && git restore tg_bot.py
- git status: пусто; grep: bet-edge-primary / bet-edge-free
- stash@{0} dropped (4d5cd83), stash list пуст

## Result
PASS (rejected, no commit). Регрессия отброшена, история не засорена
обратным коммитом. HEAD уже корректен, отдельный коммит не требуется.

## Note
Шаг B в исходной формулировке ("вернуть free-tier через коммит") был
ошибочным: HEAD уже содержал правильные значения, dirty-изменение было
регрессией. Правильное действие — discard, не commit. Исправлено до
коммита.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- PRETHEORY A7 (верификация после каждого шага)
- PRETHEORY A9 (git status ДО и ПОСЛЕ)
