#!/usr/bin/env bash
set -uo pipefail
# Ensure dshh/npm-global on PATH even when run from cron/systemd (no login shell).
export PATH="$HOME/NEE/bin:$HOME/.npm-global/bin:$PATH"

ORCH_HOME="${DSH_ORCH_HOME:-$HOME/.dsh-orch}"
REPO="${DSH_ORCH_REPO:-$HOME/BET-ANALYZER}"
NEE_LOGS="${DSH_ORCH_NEE_LOGS:-$HOME/NEE/logs}"
SYSTEM_PROMPT_FILE="$ORCH_HOME/system.md"
HINTS_DIR="$ORCH_HOME/hints"
HISTORY_DIR="$ORCH_HOME/history"
mkdir -p "$ORCH_HOME" "$HINTS_DIR" "$HISTORY_DIR"

if [ -t 1 ]; then
  BOLD=$'\e[1m'; DIM=$'\e[2m'; RED=$'\e[31m'; GRN=$'\e[32m'; YEL=$'\e[33m'; BLU=$'\e[34m'; RST=$'\e[0m'
else
  BOLD=""; DIM=""; RED=""; GRN=""; YEL=""; BLU=""; RST=""
fi

ensure_defaults() {
  if [ ! -f "$SYSTEM_PROMPT_FILE" ]; then
    cat > "$SYSTEM_PROMPT_FILE" <<'EOF'
# DSH Orchestrator — System Prompt

## Project
BET-ANALYZER, workspace ~/BET-ANALYZER. Baseline: 185 passed.
ARTEM: Reality Before Assumptions; One Step = One Commit; Each Step Leaves Evidence.

## Invariants (MUST)
- HTTP: requests.Session(trust_env=False, timeout=15, follow_redirects=True).
  Env has DEAD http_proxy=127.0.0.1:8118; without trust_env=False -> curl exit 7.
- httpx is NOT installed — use requests.
- footbolno.ru CSV: MUST set r.encoding='utf-8' before parsing (no charset in response).
- EVR artifact: write ./EVR-<NNNN>-<slug>.md in WORKSPACE ROOT.
  DO NOT create nested NEE/, DO NOT write to NEE-logs/ (sandbox read-only).
- Secrets: never print. Never commit .env.

## Style
- No print() in library code — use logging.
- Type hints + dataclasses where sensible.
- Tests: unittest + unittest.mock, no real network.
EOF
  fi
  [ -f "$HINTS_DIR/trust_env.hint" ] || cat > "$HINTS_DIR/trust_env.hint" <<'EOF'
HTTP MUST use requests.Session(trust_env=False, timeout=15, follow_redirects=True).
Env http_proxy=127.0.0.1:8118 is DEAD; without trust_env=False you get exit 7.
EOF
  [ -f "$HINTS_DIR/evr.hint" ] || cat > "$HINTS_DIR/evr.hint" <<'EOF'
Artifact: write EVR-<NNNN>-<slug>.md to WORKSPACE ROOT only.
Do NOT create NEE/ subdir. Do NOT write to NEE-logs/ (sandbox read-only).
EOF
  [ -f "$HINTS_DIR/no_code_change.hint" ] || cat > "$HINTS_DIR/no_code_change.hint" <<'EOF'
Constraint: READ-ONLY task. Do NOT modify existing modules. Only read or create new files.
EOF
  [ -f "$HINTS_DIR/baseline.hint" ] || cat > "$HINTS_DIR/baseline.hint" <<'EOF'
Baseline test count: 185 passed. Do NOT regress.
Run ./run_tests.sh before and after if you change anything.
EOF
  [ -f "$HINTS_DIR/commit_style.hint" ] || cat > "$HINTS_DIR/commit_style.hint" <<'EOF'
One atomic step = one commit. Do not commit unrelated changes.
Check git status --short before and after.
EOF
}
ensure_defaults

run_git_status() { ( cd "$REPO" 2>/dev/null && git status --short ) || echo "(not a git repo: $REPO)"; }

new_session_dir() {
  local ts; ts=$(date +%Y%m%d-%H%M%S)
  local d="$HISTORY_DIR/$ts"
  mkdir -p "$d"
  echo "$d"
}

pick_hints() {
  PICKED_HINTS=""
  local files=("$HINTS_DIR"/*.hint)
  [ -e "${files[0]}" ] || return 0
  echo "${BOLD}Hints (space-separated numbers, ENTER to skip):${RST}"
  local i=1
  for f in "${files[@]}"; do
    printf "  %2d) %s\n" "$i" "$(basename "$f" .hint)"
    i=$((i+1))
  done
  read -r -p "> " selection
  for n in $selection; do
    if [[ "$n" =~ ^[0-9]+$ ]] && [ "$n" -ge 1 ] && [ "$n" -le "${#files[@]}" ]; then
      local name; name=$(basename "${files[$((n-1))]}" .hint)
      PICKED_HINTS+="$name "
    fi
  done
}

compose_prompt() {
  local task="$1"
  local out=""
  out+="$(cat "$SYSTEM_PROMPT_FILE")"$'\n\n'
  if [ -n "${PICKED_HINTS:-}" ]; then
    out+="## Hints (active)"$'\n'
    for h in $PICKED_HINTS; do
      out+="--- $h ---"$'\n'
      out+="$(cat "$HINTS_DIR/$h.hint")"$'\n'
    done
    out+=$'\n'
  fi
  out+="## Task"$'\n'"$task"$'\n'
  printf '%s' "$out"
}

read_multiline() {
  local var="$1" line buf=""
  while IFS= read -r line; do
    [ -z "$line" ] && break
    buf+="$line"$'\n'
  done
  # Quote-safe (no eval): preserves $, ", `, \ in user input.
  printf -v "$var" '%s' "$buf"
}

run_dsh_task() {
  local prompt="$1" dir="$2"
  echo "$prompt" > "$dir/prompt.txt"
  run_git_status > "$dir/git-before.txt"
  # Snapshot EVR before dshh: only *new* files will be offered for move.
  { ( cd "$REPO" 2>/dev/null && ls -1 EVR-*.md NEE/logs/EVR-*.md 2>/dev/null ) || true; } > "$dir/evr-before.txt"
  echo "${DIM}prompt     -> $dir/prompt.txt${RST}"
  echo "${DIM}git-before -> $dir/git-before.txt${RST}"
  echo
  echo "${BOLD}=== running dshh ===${RST}"
  local rc=0
  local attempt
  for attempt in 1 2; do
    stdbuf -oL -eL timeout 180 dshh "$prompt" 2>&1 | stdbuf -oL -eL tee "$dir/response.txt" || rc=$?
    if [ "$rc" -ne 0 ] && grep -qE '503|resource_pressure|Service temporarily unavailable' "$dir/response.txt"; then
      echo "${YEL}[dshh] 503 resource_pressure, retry in 30s (attempt $attempt/2)${RST}"
      sleep 30
      continue
    fi
    break
  done
  echo
  echo "${BOLD}=== dshh exit: $rc ===${RST}"
  run_git_status > "$dir/git-after.txt"
  echo "${BOLD}=== git status after ===${RST}"
  cat "$dir/git-after.txt"
  nee_status="$(cd "$HOME/NEE" 2>/dev/null && git status --short)" || nee_status=""
  if [ ! -s "$dir/git-after.txt" ] && [ -z "$nee_status" ] \
     && grep -qiE "(successfully (created|completed|modified|updated|closed)|I'?ve (completed|created|written|modified|updated|closed)|(have been |was |been )?(recorded|saved|written) (in|to) (the )?file)" "$dir/response.txt"; then
    echo "${RED}${BOLD}=== [WARN A42] dshh claims success but git status EMPTY in BET-ANALYZER and NEE ===${RST}"
    echo "${RED}Likely hallucination. Check: $dir/response.txt${RST}"
  fi
  local moved=0
  # Diff: only EVR files that appeared *during this run*.
  { ( cd "$REPO" 2>/dev/null && ls -1 EVR-*.md NEE/logs/EVR-*.md 2>/dev/null ) || true; } > "$dir/evr-after.txt"
  local new_evrs
  new_evrs=$(comm -13 "$dir/evr-before.txt" "$dir/evr-after.txt" 2>/dev/null || true)
  if [ -n "$new_evrs" ]; then
    # fd 3 for loop input; inner `read -p` still reads from terminal (stdin).
    while IFS= read -r rel <&3; do
      [ -z "$rel" ] && continue
      local p="$REPO/$rel"
      [ -e "$p" ] || continue
      echo
      echo "${YEL}EVR (new this run): $p${RST}"
      read -r -p "Move to $NEE_LOGS? [y/N] " a
      if [[ "$a" =~ ^[Yy]$ ]]; then
        mkdir -p "$NEE_LOGS"
        mv "$p" "$NEE_LOGS/" && chmod 644 "$NEE_LOGS/$(basename "$p")"
        moved=1
      fi
    done 3<<< "$new_evrs"
  fi
  [ "$moved" = 1 ] && ( cd "$REPO" && rmdir NEE/logs NEE 2>/dev/null; true )
  echo
  echo "${DIM}session: $dir${RST}"
}

tmpl_probe() {
  local dir; dir=$(new_session_dir)
  echo "Probe template — READ-ONLY."
  echo "fields: what to verify / commands / expected / result meaning"
  read -r -p "accept default probe task? [Y/n] " a
  local task
  if [[ "$a" =~ ^[Nn]$ ]]; then
    echo "enter task (empty line to end):"; read_multiline task
  else
    task="Reality-check probe. READ-ONLY (do not modify any code).
1) Verify: <fill in>.
2) Commands + exact output.
3) Result: PASS/FAIL/PARTIAL + implication.
Artifact: EVR-<NNNN>-<slug>.md in WORKSPACE ROOT."
  fi
  PICKED_HINTS="no_code_change evr"
  run_dsh_task "$(compose_prompt "$task")" "$dir"
  read -r -p "ENTER..." _
}

tmpl_module() {
  local dir; dir=$(new_session_dir)
  read -r -p "module path (e.g. providers/foo.py): " MOD
  read -r -p "purpose (one line): " PURPOSE
  read -r -p "tests path (e.g. tests/test_foo.py): " TEST
  echo "extra notes (empty line to end):"; local notes; read_multiline notes
  local task="Implement $MOD — $PURPOSE.
Only NEW files: $MOD and $TEST. Do NOT modify existing modules (wire = separate step).
$notes
Run: python -m py_compile $MOD && .venv/bin/python -m pytest $TEST -v
Artifact: EVR-<NNNN>-<slug>.md in WORKSPACE ROOT (do NOT create NEE/ subdir)."
  PICKED_HINTS="trust_env evr baseline"
  run_dsh_task "$(compose_prompt "$task")" "$dir"
  read -r -p "ENTER..." _
}

tmpl_loop() {
  local dir; dir=$(new_session_dir)
  read -r -p "module: " MOD
  read -r -p "test file: " TEST
  read -r -p "task (short): " TASK
  echo "will run: ./dsh-loop.sh $MOD $TEST \"$TASK\""
  read -r -p "proceed? [y/N] " a
  [[ ! "$a" =~ ^[Yy]$ ]] && return
  ( cd "$REPO" && ./dsh-loop.sh "$MOD" "$TEST" "$TASK" ) 2>&1 | tee "$dir/response.txt"
  read -r -p "ENTER..." _
}

tmpl_evr() {
  local dir; dir=$(new_session_dir)
  echo "topic for EVR (empty line to end):"; local topic; read_multiline topic
  [ -z "$topic" ] && return
  local task="Produce ONLY an EVR report. Do NOT modify any code.
Topic: $topic
Structure: Object / Environment / Expected / Observed / Result (PASS|FAIL|PARTIAL).
Artifact: EVR-<NNNN>-<slug>.md in WORKSPACE ROOT. Do not create NEE/ subdir."
  PICKED_HINTS="no_code_change evr"
  run_dsh_task "$(compose_prompt "$task")" "$dir"
  read -r -p "ENTER..." _
}

menu_main() {
  clear
  echo "${BOLD}=== DSH Orchestrator ===${RST}"
  echo "repo: $REPO"
  echo "orch: $ORCH_HOME"
  echo "logs: $NEE_LOGS"
  echo
  echo "  1) New task (free-form, no hints)"
  echo "  2) New task with hints"
  echo "  3) Probe template (read-only)"
  echo "  4) Module template"
  echo "  5) dsh-loop.sh launcher"
  echo "  6) EVR-only report"
  echo "  7) Edit system prompt"
  echo "  8) Manage hints"
  echo "  h) History"
  echo "  g) git status / commit"
  echo "  0) Quit"
  echo
  read -r -p "> " c
  case "$c" in
    1) local dir; dir=$(new_session_dir); echo "task (empty line to end):"; local t; read_multiline t
       [ -z "$t" ] && return; PICKED_HINTS=""
       run_dsh_task "$(compose_prompt "$t")" "$dir"; read -r -p "ENTER..." _ ;;
    2) local dir; dir=$(new_session_dir); pick_hints
       echo "task (empty line to end):"; local t; read_multiline t
       [ -z "$t" ] && return
       run_dsh_task "$(compose_prompt "$t")" "$dir"; read -r -p "ENTER..." _ ;;
    3) tmpl_probe ;;
    4) tmpl_module ;;
    5) tmpl_loop ;;
    6) tmpl_evr ;;
    7) "${EDITOR:-nano}" "$SYSTEM_PROMPT_FILE" ;;
    8) manage_hints ;;
    h|H) show_history ;;
    g|G) git_menu ;;
    0|q|Q) exit 0 ;;
  esac
}

manage_hints() {
  while :; do
    clear
    echo "${BOLD}Hints${RST} ($HINTS_DIR)"
    local files=("$HINTS_DIR"/*.hint)
    local i=1
    for f in "${files[@]}"; do
      [ -e "$f" ] || continue
      printf "  %2d) %s\n" "$i" "$(basename "$f" .hint)"
      i=$((i+1))
    done
    echo
    echo "  a) add   e) edit   d) delete   0) back"
    read -r -p "> " c
    case "$c" in
      a) read -r -p "name: " n; "${EDITOR:-nano}" "$HINTS_DIR/$n.hint" ;;
      e) read -r -p "number: " n; [ -e "${files[$((n-1))]:-}" ] && "${EDITOR:-nano}" "${files[$((n-1))]}" ;;
      d) read -r -p "number: " n; [ -e "${files[$((n-1))]:-}" ] && rm -f "${files[$((n-1))]}" ;;
      0) return ;;
    esac
  done
}

show_history() {
  clear
  echo "${BOLD}History${RST} ($HISTORY_DIR)"
  ls -1t "$HISTORY_DIR" 2>/dev/null | head -30
  echo
  read -r -p "open latest? [y/N] " a
  if [[ "$a" =~ ^[Yy]$ ]]; then
    local latest; latest=$(ls -1t "$HISTORY_DIR" | head -1)
    echo "--- prompt ---"; head -80 "$HISTORY_DIR/$latest/prompt.txt"
    echo "--- response (tail) ---"; tail -80 "$HISTORY_DIR/$latest/response.txt"
    read -r -p "ENTER..." _
  fi
}

git_menu() {
  clear
  echo "${BOLD}git${RST} ($REPO)"
  ( cd "$REPO" && git status --short )
  echo
  echo "  c) commit all with message"
  echo "  s) stage specific files"
  echo "  l) last 5 commits"
  echo "  0) back"
  read -r -p "> " c
  case "$c" in
    c) read -r -p "message: " m; ( cd "$REPO" && git add -A && git commit -m "$m" ) ;;
    s) read -r -p "files (space-sep): " fs; ( cd "$REPO" && git add $fs && git status --short ) ;;
    l) ( cd "$REPO" && git log --oneline -5 ) ;;
  esac
  read -r -p "ENTER..." _
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  cat <<EOF
Usage:
  $0                                interactive TUI
  $0 --task "..." [--hints a,b]     one-shot
  $0 --edit-system                  open system prompt
Env:
  DSH_ORCH_HOME    default ~/.dsh-orch
  DSH_ORCH_REPO    default ~/BET-ANALYZER
  DSH_ORCH_NEE_LOGS default ~/NEE/logs
EOF
  exit 0
fi
if [ "${1:-}" = "--edit-system" ]; then
  "${EDITOR:-nano}" "$SYSTEM_PROMPT_FILE"; exit 0
fi
if [ "${1:-}" = "--task" ]; then
  shift; TASK=""; HINTS=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --hints) HINTS="${2//,/ }"; shift 2 ;;
      *) TASK+="$1 "; shift ;;
    esac
  done
  PICKED_HINTS="$HINTS"
  local_dir=$(new_session_dir)
  run_dsh_task "$(compose_prompt "$TASK")" "$local_dir"
  exit 0
fi

trap 'echo; exit 0' INT
while :; do menu_main; done
