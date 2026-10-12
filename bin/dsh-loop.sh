#!/usr/bin/env bash
# dsh-loop.sh — semi-autonomous test-authoring loop via DSH.
set -euo pipefail

MODULE="${1:?module required}"
TEST_FILE="${2:?test file required}"
TASK="${3:?task required}"

REPO=~/BET-ANALYZER
NEE=~/NEE
LOGDIR="$NEE/logs/dsh-loop-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$LOGDIR"

cd "$REPO"

echo "[pre-flight] git status"
git status --porcelain | tee "$LOGDIR/pre-flight-git.txt"
if [ -s "$LOGDIR/pre-flight-git.txt" ]; then
    echo "[abort] working tree not clean."
    exit 1
fi

echo "[pre-flight] py_compile $MODULE"
python3 -m py_compile "$MODULE" || { echo "[abort] module doesn't compile"; exit 1; }

echo "[pre-flight] baseline tests"
./run_tests.sh 2>&1 | tail -5 | tee "$LOGDIR/pre-flight-tests.txt"
BASELINE=$(grep -oP '\d+(?= passed)' "$LOGDIR/pre-flight-tests.txt" | head -1)
echo "[pre-flight] baseline: $BASELINE passed"

MAX_ITER=3
for i in $(seq 1 $MAX_ITER); do
    echo
    echo "================ ITERATION $i / $MAX_ITER ================"

    if [ "$i" -eq 1 ]; then
        PROMPT="Задача: $TASK.

Файл модуля: $MODULE.
Файл тестов: $TEST_FILE.

Прочитай $MODULE. Предложи 5-8 unit-тестов с unittest + unittest.mock.

Формат ответа:
1. Полный код файла $TEST_FILE (готовый для записи через cat).
2. Команды проверки.

Только код, без объяснений."
    else
        TRACEBACK=$(tail -80 "$LOGDIR/iter-$((i-1))-pytest.txt" 2>/dev/null || echo "no traceback")
        PROMPT="Предыдущая итерация провалилась.

Traceback:
$TRACEBACK

Пересмотри код $TEST_FILE. Исправь.
Формат: полный код $TEST_FILE заново.
Только код."
    fi

    echo "$PROMPT" > "$LOGDIR/iter-$i-prompt.txt"
    dshh "$PROMPT" > "$LOGDIR/iter-$i-response.txt" 2>&1
    echo "[propose] saved to $LOGDIR/iter-$i-response.txt"

    echo
    echo "[GATE] Проверь вручную: $LOGDIR/iter-$i-response.txt"
    echo "  1. Открой файл в другом терминале."
    echo "  2. Скопируй код в $TEST_FILE (создай или перезапиши)."
    echo "  3. Убедись что assertions соответствуют исходнику $MODULE."
    echo "  4. Нажми ENTER здесь, если продолжить, или Ctrl+C для отмены."
    read -r

    if ! python3 -m py_compile "$TEST_FILE" 2>"$LOGDIR/iter-$i-compile.txt"; then
        echo "[compile] FAILED"
        cat "$LOGDIR/iter-$i-compile.txt"
        continue
    fi
    echo "[compile] OK"

    if PYTHONPATH=. .venv/bin/python -m pytest "$TEST_FILE" -v \
        > "$LOGDIR/iter-$i-pytest.txt" 2>&1; then
        echo "[test] PASS"
        break
    else
        echo "[test] FAIL — see $LOGDIR/iter-$i-pytest.txt"
        if [ "$i" -eq "$MAX_ITER" ]; then
            echo "[abort] max iterations. Manual review."
            exit 2
        fi
    fi
done

echo
echo "================ FINALIZE ================"
./run_tests.sh 2>&1 | tail -5 | tee "$LOGDIR/final-tests.txt"
FINAL=$(grep -oP '\d+(?= passed)' "$LOGDIR/final-tests.txt" | head -1)

if [ "$FINAL" -lt "$BASELINE" ]; then
    echo "[abort] regression: $BASELINE -> $FINAL"
    exit 3
fi

git add "$TEST_FILE"
git diff --cached --stat | tee "$LOGDIR/final-diff.txt"
echo
echo "[review] Commit? (y/N)"
read -r ANS
if [ "$ANS" = "y" ]; then
    MSG="test: add unit tests for $(basename $MODULE)"
    git commit -m "$MSG"
    echo "[committed] $MSG"
else
    echo "[skipped commit]"
fi
