#!/usr/bin/env bash
set -euo pipefail
unset HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy
export NO_PROXY="127.0.0.1,localhost,::1"
export no_proxy="$NO_PROXY"
exec /home/jail/.nvm/versions/node/v22.23.2/bin/node \
  /home/jail/.nvm/versions/node/v22.23.2/lib/node_modules/omniroute/bin/omniroute.mjs \
  serve --no-open --port 20128
