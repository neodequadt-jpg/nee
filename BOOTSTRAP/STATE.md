# ENGINEERING STATE

## Ecosystem
NEE

## Current Repository
BET-ANALYZER

## Stack
- opera-proxy (127.0.0.1:18080)
- OmniRoute (127.0.0.1:20128) -> VPS SOCKS5 (45.11.24.103:1080)
- Telegram bot

## LLM
- Primary: groq/openai/gpt-oss-120b (WORKS via VPS)
- Gemini: BLOCKED (EEA requires billing)
- Fallback: none

## Known Issues
- Gemini API unavailable from EEA without billing
- Smarkets timeouts (read timeout=6)
- Telegram getUpdates timeouts (read timeout=8)

## Verified
- EVR-0002 PASS: nee + OmniRoute + VPS + Bootstrap

## Current Priority
- Stabilize BET-ANALYZER polling
- Fix Smarkets timeouts
