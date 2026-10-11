#!/usr/bin/env python3
"""nee — terminal wrapper for ARTEM/NEE engineering sessions."""
import os
import sys
from pathlib import Path

from openai import OpenAI
from dotenv import load_dotenv

# NEE_NO_PROXY_INJECTED
os.environ.setdefault("NO_PROXY", "127.0.0.1,localhost,::1")
os.environ.setdefault("no_proxy", "127.0.0.1,localhost,::1")

NEE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(NEE_DIR / ".env")

BOOTSTRAP_ORDER = [
    "MANIFEST.md",
    "STATE.md",
    "ARCHITECTURE.md",
    "CONSTRAINTS.md",
    "CURRENT_GOAL.md",
]

def load_bootstrap() -> str:
    parts = []
    for name in BOOTSTRAP_ORDER:
        fpath = NEE_DIR / "BOOTSTRAP" / name
        if fpath.exists():
            parts.append(f"===== {name} =====\n{fpath.read_text(encoding='utf-8')}")
    return "\n\n".join(parts)

def main():
    if len(sys.argv) < 2:
        print('Usage: nee "query"')
        sys.exit(1)

    query = " ".join(sys.argv[1:])
    system_prompt = load_bootstrap()

    client = OpenAI(
        base_url=os.getenv("OMNIROUTE_URL", "http://127.0.0.1:20128/v1"),
        api_key=os.getenv("OMNIROUTE_API_KEY", "any"),
    )

    try:
        response = client.chat.completions.create(
            model=os.getenv("DEFAULT_MODEL", "auto"),
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": query},
            ],
            temperature=0.2,
        )
        print(response.choices[0].message.content)
    except Exception as e:
        print(f"[nee] error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
