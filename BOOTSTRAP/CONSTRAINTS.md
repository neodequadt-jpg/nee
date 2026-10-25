# CONSTRAINTS

## Forbidden
- Redesign Core
- Rename Core concepts
- Skip Research
- Skip Validation
- Manual editing if automation is possible
- Invented dependencies

## Required
- Specification First
- Research Before Implementation
- Evidence Before Authority
- Reality Before Assumptions
- One Engineering Goal = One Commit
- Verification before Push

## Communication Mode
- Maximum engineering density
- No philosophy
- No motivation
- Only commands, patches, code, verification

## Operational pre-theory

Правила, выведенные из инцидентов: ~/NEE/ARTEM-PRETHEORY.md
Пополняется ad hoc: одно правило = один инцидент. Ссылается из EVR.

## Security incidents
- 2026-10-12: leak of BOT_TOKEN, OMNI_KEY, WG private key in transcript.
  All three rotated.
  - BOT_TOKEN: revoked @BotFather, new one in ~/.bet_env, verified via getMe.
  - OMNI_KEY/OMNIROUTE_API_KEY: regenerated via UI, updated in .bet_env.
  - WG: new keypair, new peer on VPS, old peer removed, MTU 1280,
    MSS clamp active on VPS FORWARD chain.
  Procedures in ARTEM-PRETHEORY M4, E6, E7.

## Secrets in git history (known, accepted)
- 0fa68a2: tg_bot.py contained OMNI_KEY fallback "sk-8445...".
  Key rotated 2026-10-12. History NOT rewritten (no force-push
  to main; zero exploitability — OmniRoute client keys not validated).
- Rule for future: any secret in source is P1; rotate first,
  then decide on history rewrite case-by-case.

## Secrets in git history (known, accepted)
- 0fa68a2: tg_bot.py contained OMNI_KEY fallback "sk-8445...".
  Key rotated 2026-10-12. History NOT rewritten (no force-push
  to main; zero exploitability — OmniRoute client keys not validated).
- Rule for future: any secret in source is P1; rotate first,
  then decide on history rewrite case-by-case.

## Backtest signals — gitignored
- data/backtest/signals/ — в .gitignore. 18 fixtures в индексе (git add -f).
- Остальные signals — untracked, могут пропасть при rm/clean.
- data/backtest/results/ — тоже gitignored, но воспроизводимы resolve_all().
- EVR-0016 (348 signals) — исторический, не воспроизводим.
