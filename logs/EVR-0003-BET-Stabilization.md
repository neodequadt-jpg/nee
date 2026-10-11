# EVR-0003 — BET-ANALYZER Stabilization

## Object
Smarkets timeouts + Telegram getUpdates instability

## Environment
- LMDE + WireGuard wg0 (split-tunnel to VPS 45.11.24.103)
- OmniRoute v16.3.1 (127.0.0.1:20128)
- LLM: groq/openai/gpt-oss-120b
- Bot: @bet_analyzer_anrhytm_bot

## Changes
1. bookmakers/smarkets_provider.py: timeout 6→15, retries 1→3 (×3)
2. tg_bot.py: HTTP_TIMEOUT 8→25
3. bot.sh: SOCKS5 → WireGuard split-tunnel
4. bot.sh: PYTHONUNBUFFERED=1
5. .env.bot: valid BOT_TOKEN
6. /etc/resolv.conf: static (192.168.1.1, 1.1.1.1, 8.8.8.8), immutable

## Root Cause
- opera-proxy flaky (30% timeouts)
- SOCKS5: TLS handshake per request → 1-8s
- Dead CF Worker relay
- Invalid BOT_TOKEN
- systemd-resolved intermittent failures

## Validation
- ip route get 149.154.167.220 → dev wg0
- curl getMe: 10/10 HTTP 200, avg 0.25s
- getUpdates failed: 0
- tunnel warm after 1 ping
- smarkets warmed: 2 (was 0)

## Result
PASS
