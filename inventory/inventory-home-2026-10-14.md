## 1. TOP-10 — самое полезное для BET-ANALYZER

| # | Что | Путь | Тип | Зачем полезно | Риск |
|---|---|---|---|---|---|
| 1 | ARTEM-CORE.md | `~/NEE/ARTEM-CORE.md` | doc | Методология — 5 правил, 3 артефакта, цикл. Основа всего | LOW |
| 2 | ARTEM-PRETHEORY.md | `~/NEE/ARTEM-PRETHEORY.md` | doc | Правила из инцидентов (M4, E6, E7 — секреты, прокси) | LOW |
| 3 | BOOTSTRAP/STATE.md | `~/NEE/BOOTSTRAP/STATE.md` | doc | Текущее состояние: goals, stack, known issues, baseline | LOW |
| 4 | dsh-orch/system.md | `~/.dsh-orch/system.md` | skill | DSH-оркестратор: инварианты (trust_env, httpx, UA, cache TTL) | LOW |
| 5 | dsh-orch/hints/ | `~/.dsh-orch/hints/*.hint` | skill | 5 хинтов: baseline, commit_style, evr, trust_env, no_code_change | LOW |
| 6 | bonus-cron.timer | `~/.config/systemd/user/bonus-cron.timer` | service | Крон 00/06/12/18:05 MSK — уже работает, не трогать | MEDIUM |
| 7 | prompts/sports_betting_ru.txt | `~/BET-ANALYZER/prompts/` | doc | Промпт для AI-ассистента ставок — переиспользуем | LOW |
| 8 | scripts/bonus_cron.py | `~/BET-ANALYZER/scripts/` | script | Bonus snapshot → Telegram alert, вызывается таймером | MEDIUM |
| 9 | scripts/fetch_injuries.py | `~/BET-ANALYZER/scripts/` | script | Sync Flashscore missing players → data/injuries/ | MEDIUM |
| 10 | OmniRoute services | `~/.omniroute/services/` | config | 9router, bifrost, cliproxy, dario, mux — маршрутизация LLM | HIGH |

---

## 2. Полный каталог по категориям

### A) Скрипты (переиспользуемые)

- `~/BET-ANALYZER/scripts/bonus_cron.py` — bonus snapshot + Telegram alert (вызывается systemd timer)
- `~/BET-ANALYZER/scripts/fetch_injuries.py` — Flashscore injuries sync
- `~/NEE/bin/dsh-loop.sh` — DSH итерационный цикл
- `~/NEE/bin/codex-or` — Codex orchestrator wrapper
- `~/NEE/bin/dshh` — DSH headless runner
- `~/NEE/bin/dsh-orch.sh` — DSH orchestrator shell
- `~/.dsh/bin/dsh-auto.sh` — DSH auto-wrapper (cooldown, model rotation, git rollback)
- `~/bin/dsh-auto` → symlink на `~/.dsh/bin/dsh-auto.sh`
- `~/gthubsearch/app.py` — Flask GitHub repo search (Flask + GitHub API)

### B) Конфиги (systemd / autostart / desktop)

- `~/.config/systemd/user/bonus-cron.service` — oneshot, WorkingDirectory=BET-ANALYZER, ExecStart=bonus_cron.py
- `~/.config/systemd/user/bonus-cron.timer` — OnCalendar `*-*-* 00,06,12,18:05:00`, Persistent, RandomizedDelaySec=300
- `~/.config/autostart/omniroute.desktop` — OmniRoute autostart (не работает headless — known issue)
- `~/.config/autostart/mintupdate.desktop`, `mintwelcome.desktop`, `geoclue-demo-agent.desktop`, `remmina-applet.desktop`

### C) Данные (JSON / CSV / sqlite)

- `~/BET-ANALYZER/data/bonuses.json` — текущие бонусы
- `~/BET-ANALYZER/data/bonuses_snapshot.json` — snapshot (gitignored)
- `~/BET-ANALYZER/data/bookmakers.json` — букмеры
- `~/BET-ANALYZER/data/mid_map.json` — match ID map
- `~/BET-ANALYZER/data/subscribers.json` — подписчики TG
- `~/BET-ANALYZER/data/state.json` — состояние
- `~/BET-ANALYZER/data/backtest/` — бэктест сигналы/результаты (gitignored)
- `~/BET-ANALYZER/data/injuries/` — injuries cache
- `~/.omniroute/storage.sqlite` — 25MB, OmniRoute storage
- `~/.codex/goals_1.sqlite`, `logs_2.sqlite`, `memories_1.sqlite`, `state_5.sqlite`, `thread_history_1.sqlite` — Codex internals

### D) Документы (MD / txt)

- `~/NEE/ARTEM-CORE.md` — методология (5 правил)
- `~/NEE/ARTEM-PRETHEORY.md` — pre-theory из инцидентов
- `~/NEE/BOOTSTRAP/STATE.md` — engineering state
- `~/NEE/BOOTSTRAP/CURRENT_GOAL.md` — текущая цель (нет активной, кандидаты G-0015, G-0016)
- `~/NEE/BOOTSTRAP/MANIFEST.md` — манифест NEE
- `~/NEE/BOOTSTRAP/CONSTRAINTS.md` — ограничения + security incidents
- `~/NEE/BOOTSTRAP/ARCHITECTURE.md` — архитектура (FROZEN)
- `~/NEE/features/001-stats.md` — feature spec
- `~/BET-ANALYZER/docs/DSH-AUTO.md` — DSH auto-wrapper docs
- `~/BET-ANALYZER/docs/artem/MILESTONE-dsh-auto-v4.2.md` — milestone
- `~/BET-ANALYZER/G-0013-SPEC.md`, `G-0015-PLAN-SPEC.md` — goal specs
- `~/BET-ANALYZER/EVR-0015-codex-install.md` — EVR
- `~/BET-ANALYZER/README.md`, `MANIFEST_BET_TG.md` — проектные доки
- `~/Документы/api-omni-router.txt` — OmniRouter API notes
- `~/Документы/cliproxy-logs.txt` — cliproxy notes
- `~/Документы/deepseek_text_20260930_01615f.txt` — DeepSeek output
- `~/Документы/Анализ и продолжение.txt` — анализ/планы

### E) Skill / промпты (DSH)

- `~/.dsh/specs/_TEMPLATE.md` — шаблон спецификации
- `~/.dsh/specs/fix-value-quality.md` — спецификация фикса value quality
- `~/.dsh/tasks/` — **49 task specs** (bot_polish, i18n, live_command, resolver, rate_limit, rag_sports_data, sort_by_kickoff, sports_data_v1/v2, today_express, и т.д.)
- `~/.dsh/profiles/headless/`, `tui/`, `web/` — 3 профиля DSH
- `~/.dsh-orch/system.md` — системный промпт оркестратора
- `~/.dsh-orch/hints/` — 5 хинтов (baseline, commit_style, evr, no_code_change, trust_env)
- `~/BET-ANALYZER/prompts/sports_betting_ru.txt` — AI-промпт ставок

### F) Env-файлы (только имена ключей)

| Файл | Ключи |
|---|---|
| `~/BET-ANALYZER/.env` | `FOOTBALL_DATA_KEY` |
| `~/BET-ANALYZER/.env.bot` | `BOT_TOKEN`, `TG_ADMIN_ID` |
| `~/BET-ANALYZER/.env.bot.example` | `BOT_TOKEN`, `TG_ADMIN_ID`, `OMNI_KEY`, `OMNIROUTE_API_KEY`, `FOOTBALL_DATA_KEY` |
| `~/NEE/.env` | `OMNIROUTE_URL`, `OMNIROUTE_API_KEY`, `DEFAULT_MODEL`, `NO_PROXY`, `no_proxy` |
| `~/.omniroute/.env` | `STORAGE_ENCRYPTION_KEY`, `OMNIROUTE_SERVER_HOST`, `OMNIROUTE_SERVER_PORT`, `http_proxy`, `https_proxy`, `HTTP_PROXY`, `HTTPS_PROXY`, `all_proxy`, `ALL_PROXY` |

### G) Cron / systemd timers

- **bonus-cron.timer** — активен, `*-*-* 00,06,12,18:05:00 MSK`, Persistent, RandomizedDelaySec=300
- **bonus-cron.service** — oneshot, `scripts/bonus_cron.py`
- `crontab -l` — пустой

### H) Notes / TODO / ideas

- `~/NEE/BOOTSTRAP/CURRENT_GOAL.md` — кандидаты: G-0015 (wire /bonuses in tg_bot), G-0016 (API-Football fallback)
- Tech debt: EVR-0023 missing, OmniRoute autostart broken, OMNIROUTE_API_KEY leaked in dshh, ALL_PROXY rudiment
- `~/Документы/Анализ и продолжение.txt` — анализ/планы

---

## 3. Мусор / кандидаты на удаление

| Что | Почему |
|---|---|
| `~/echo`, `~/shell` | 0-байтные файлы |
| `~/report.json`, `~/report.JSON` | 0-байтные дубли |
| `~/adb.txt`, `~/link.txt` | 0-байтные |
| `~/opera-proxy-bin` | 0-байтный бинарник |
| `~/.dsh/settings.yaml.bak.*` | **11 бэкапов** settings.yaml (Sep-Oct) |
| `~/.dsh/lib.pre-migrate.bak/` | старая lib до миграции |
| `~/.dsh/bin/dsh-auto.sh.pre-migrate.bak`, `.v3.bak`, `.v4.bak`, `.v41.bak` | 4 старых бэкапа dsh-auto |
| `~/BET-ANALYZER/tg_bot.py.bak.1791877429` | бэкап tg_bot |
| `~/BET-ANALYZER/.env.bot.bak`, `.env.bot.bak.1791730828` | 2 бэкапа env.bot |
| `~/NEE/.env.bak.1791823803` | бэкап NEE env |
| `~/phoenixin_in_global_images_V12.0.2.0.QGHINXM_*` | 3 Xiaomi firmware файла/папки (дубли?) |
| `~/platform-tools_r29.0.6-linux.zip.1` | дубликат zip |
| `~/gost_3.0.0_linux_amd64.gz.1` | дубликат |

---

## 4. НЕ трогать

- `~/.dsh/.credentials.yaml` — DSH credentials
- `~/.dsh/settings.yaml` — DSH settings (модели, ключи)
- `~/.dsh/sessions/` — DSH сессии
- `~/.dsh/storages/` — DSH storage
- `~/.omniroute/.env` — OmniRoute encryption key + proxy creds
- `~/.omniroute/storage.sqlite` — 25MB, живая БД OmniRoute
- `~/.codex/auth.json.bak.*` — Codex auth
- `~/.codex/config.toml` — Codex config (модель, провайдер)
- `~/NEE/.env` — API ключи (OMNIROUTE_API_KEY, DEFAULT_MODEL)
- `~/BET-ANALYZER/.env`, `.env.bot` — BOT_TOKEN, FOOTBALL_DATA_KEY
- `~/BET-ANALYZER/.aws/` — AWS credentials
- `~/NEE/bin/dshh` — содержит засвеченный OMNIROUTE_API_KEY (known issue)
- Git history commit `0fa68a2` — содержит старый OMNI_KEY (ротирован, но в истории)

---

## 5. Вопросы

1. `~/gthubsearch/` — Flask GitHub search app. Используется? Связано с BET-ANALYZER?
2. `~/Документы/rockyou.txt` — это словарь паролей? Зачем?
3. `~/bully/` — что внутри? (имя подозрительное)
4. `~/6360/`, `~/hs/`, `~/trio/` — что это за директории?
5. `~/NEE/bin/dshh` — OMNIROUTE_API_KEY засвечен (CONSTRAINTS.md упоминает). Ротировать?
6. `ALL_PROXY=socks://45.11.24.103:1080` в `~/.omniroute/.env` — VPS SOCKS рудимент. Удалить?
7. G-0015 и G-0016 — какой приоритет? Оба или один?
8. `~/phoenix_*` / `~/twrp-phoenix.img` / `~/wileyfox_firmware` — старые прошивки для другого телефона. Удалить?

---

Ничего не применено, не изменено, не создано.
