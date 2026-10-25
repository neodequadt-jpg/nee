#!/usr/bin/env bash
set -euo pipefail

# Clean dead proxy env (shell inherits ALL_PROXY=socks://...)
unset HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy
export NO_PROXY="127.0.0.1,localhost,::1"
export no_proxy="$NO_PROXY"

# Load ~/.bet_env (shell-style with export)
if [ -f "$HOME/.bet_env" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$HOME/.bet_env"
  set +a
fi

: "${BOT_TOKEN:?BOT_TOKEN not set}"

cd /home/jail/BET-ANALYZER
exec /home/jail/BET-ANALYZER/.venv/bin/python /home/jail/BET-ANALYZER/tg_bot.py
