# EVR-0038 — P1: OMNI_KEY leaked in .codex-home transcript (ROTATED)

Object: current OMNI_KEY/OMNIROUTE_API_KEY from ~/.bet_env
Environment: jailLMDE, ~/BET-ANALYZER/.codex-home/sessions
Date: 2026-10-26

## Expected
- no current secret value in project tree or agent runtimes

## Observed
- grep over .codex-home/sessions/ found 2 rollout-*.jsonl (2026-10-15
  08:31 and 09:03) with BOT_TOKEN/OMNI_KEY/sk-/Bearer patterns
- sha256 comparison against current .bet_env:
    BOT_TOKEN: 3 unique, all not-current (rotated 2026-10-12, accepted)
    OMNI_KEY: 1 unique, MATCHES_CURRENT (sha256 36b42ad84c40…, len 35)
    Bearer: same as OMNI_KEY (duplicate)
- .codex-cli (1.3G) and .codex-home (115M) lived in BET-ANALYZER cwd
- .codex* already in .gitignore (HEAD, commit 9b70224); NOT tracked
- dashboard password was reset to weak value, visible in scrollback,
  bound to 127.0.0.1 only

## Action
- rotated via OmniRoute dashboard: revoked Bet_analyzer (0ba95930…),
  CLI Auto-Key (7c2532ec…), bet-analyze (66f5288d…);
  created Bet_analyzer-2026-10-26b (active=1, last_used 01:51:19)
- updated ~/.bet_env OMNI_KEY + OMNIROUTE_API_KEY (600, len=35,
  new sha256=68fecda30068…, old=36b42ad84c40…)
- moved .codex-cli/.codex-home to ~/.codex-*-from-BET-ANALYZER-20261026
- rebuilt handoff tarball without .codex* (552M -> 1.4M compressed)
- no code change in BET-ANALYZER: .gitignore already correct

## Verification
GET /v1/models      -> HTTP 200
POST /v1/chat/...   -> HTTP 200, finish=stop
api_keys            -> only Bet_analyzer-2026-10-26b, active=1
.bet_env sha256     -> 68fecda30068… (differs from leaked 36b42ad84c40…)
du -sh ~/BET-ANALYZER -> 64M (was ~1.4G)
tarball bet-analyzer-src.tgz -> 1.4M (was 552M); clean of .codex*/.git/.venv
git ls-files .codex* -> 0

## Result
PASS.

## Note
- BOT_TOKEN in sessions: historical only, rotated 2026-10-12, no action.
- leaked OMNI_KEY sha256=36b42ad84c40… deleted from api_keys.
- ~/.codex-home-from-BET-ANALYZER-20261026 (115M) retains dead-key
  transcript; delete after review (separate step).
- dashboard password weak: rotate via reset-password with getpass.
- root cause: codex CLI launched with cwd=BET-ANALYZER; runtime belongs
  in ~/.codex, not in project.

## Rule refs
- ARTEM-CORE п.1 (Reality Before Assumptions)
- ARTEM-CORE п.3 (Each Step Leaves Evidence)
- CONSTRAINTS: Never Commit Secrets (P1; rotate first)
