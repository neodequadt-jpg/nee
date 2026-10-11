# ARTEM Core

Методология воспроизводимой инженерной работы.
Версия: 2.0
Дата: 2026-10-12

---

## 5 правил

1. **Reality Before Assumptions.**
   Любое утверждение проверяется через факты (grep, sed, curl, test), прежде чем на него опираются.

2. **One Engineering Step = One Commit.**
   Один атомарный шаг — один коммит. Без «заодно».

3. **Each Step Leaves Evidence.**
   Каждый шаг оставляет артефакт проверки: EVR, тест, лог, метрика.

4. **Bootstrap is the Only Source of Truth.**
   Контекст проекта восстанавливается из BOOTSTRAP/, а не из памяти человека или LLM.

5. **Never Commit Secrets.**
   .env, ключи, токены — в .gitignore. Только .env.example.

---

## 3 артефакта

### 1. BOOTSTRAP/
Состояние проекта между сессиями:
- MANIFEST.md — что за проект, стек, зависимости
- STATE.md — текущее состояние (verified facts)
- CURRENT_GOAL.md — одна цель
- CONSTRAINTS.md — запреты и обязательства
- ARCHITECTURE.md — зафиксированная архитектура

### 2. EVR-NNNN.md
Отчёт одной проверки:
- Object: что проверяли
- Environment: где и как
- Expected: что ожидали
- Observed: что увидели
- Result: PASS / FAIL / PARTIAL

Пишется в logs/.

### 3. CURRENT_GOAL.md
Одна цель. Не список. Закрытая цель удаляется, открывается новая.

---

## 1 цикл

Research  ->  Step  ->  Verify  ->  EVR  ->  Commit  ->  Bootstrap update

Не пропускать. Не переупорядочивать.

---

## Что НЕ входит

- Дебаты, советы, governance
- Философия, манифесты, "законы"
- RFC/ADR как обязательные артефакты (по необходимости)
- Модули, платформы, экосистемы

Всё это в ARTEM-ARCHIVE/.

---

## Проверка каждого шага

1. Увеличивает reality (проверенное знание)?
2. Оставляет evidence (EVR / тест)?
3. Восстанавливается из Bootstrap?

Если хотя бы один ответ "нет" — шаг пересматривается.
