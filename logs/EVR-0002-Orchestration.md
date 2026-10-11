# EVR-0002 — Orchestration Test

## Object
nee CLI + OmniRoute + VPS SOCKS5 + Bootstrap Manifest

## Environment
- LMDE, OmniRoute v3.8.50 on 127.0.0.1:20128
- VPS: 45.11.24.103 (Frankfurt, DE), SOCKS5 :1080
- Provider: groq / openai/gpt-oss-120b
- Proxy registry: vps-socks5-frankfurt (active)
- proxy_assignments: all combos routed via vps-socks5-frankfurt

## Expected
`nee "<query>"` returns a valid LLM response using Bootstrap as system prompt.

## Observed
Command:
  nee "Тест: ответь одним предложением, что такое ARTEM"

Response:
  "ARTEM — исследовательская программа воспроизводимой инженерии,
   определяющая workflow от исследования до спецификации."

- Bootstrap loaded: OK
- Context preserved: OK (no re-explanation of ARTEM)
- LLM backend: groq/openai/gpt-oss-120b via VPS SOCKS5
- Latency: within timeout 90s

## Result
PASS

## Notes
- Gemini API blocked from EEA (Frankfurt) without billing.
- Fallback path currently: Groq only.
- If Gemini required: relocate VPS to US/TR/JP.
