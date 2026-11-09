#!/usr/bin/env bash
set -euo pipefail

[ $# -ge 2 ] || { echo "usage: $0 G-00XX \"desc\""; exit 2; }
GOAL="$1"; DESC="$2"
DATE=$(date +%Y-%m-%d)
HEAD=$(git -C "$HOME/BET-ANALYZER" rev-parse --short HEAD)
CG="$HOME/NEE/BOOTSTRAP/CURRENT_GOAL.md"
ST="$HOME/NEE/BOOTSTRAP/STATE.md"

python3 - "$GOAL" "$DESC" "$DATE" "$HEAD" "$CG" "$ST" <<'PY'
import sys, re, pathlib
goal, desc, date, head, cg_p, st_p = sys.argv[1:7]

cg = pathlib.Path(cg_p); s = cg.read_text(encoding='utf-8')
changed = []

if f'## {goal}' in s:
    start = s.index(f'## {goal}')
    m = re.search(r'\n## ', s[start+1:])
    end = start + 1 + m.start() if m else len(s)
    s = s[:start] + 'No active goal.\n\n' + s[end:].lstrip('\n')
    changed.append(f'removed {goal} block')

entry = f'- {goal}: {desc} — {date}\n'
if f'- {goal}:' not in s:
    s = s.replace('## Recently closed\n', '## Recently closed\n' + entry, 1)
    changed.append('added to Recently closed')
cg.write_text(s, encoding='utf-8')

st = pathlib.Path(st_p); s = st.read_text(encoding='utf-8')
s2, n_head = re.subn(r'(?m)^- HEAD BET-ANALYZER: \w+$',
                     f'- HEAD BET-ANALYZER: {head}', s, count=1)
if n_head == 1:
    if s2 != s:
        changed.append(f'HEAD -> {head}')
    s = s2

gline = f'- {goal}: COMPLETED {date} — {desc}\n'
if gline not in s and '## Goals' in s:
    pos = s.index('## Goals') + len('## Goals\n')
    s = s[:pos] + gline + s[pos:]
    changed.append(f'added {goal} to Goals')
st.write_text(s, encoding='utf-8')

print('changes:', ', '.join(changed) or 'none (idempotent)')
PY

echo "close-g.sh: $GOAL -> $HEAD @ $DATE"
