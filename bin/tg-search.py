#!/usr/bin/env python3
"""tg-search — ищет публичные TG-чаты/каналы через MTProto (Telethon)."""
import argparse, asyncio, os, re, sys
from telethon import TelegramClient
from telethon.tl.functions.contacts import SearchRequest
from telethon.tl.types import Channel, Chat

API_ID = int(os.environ["TG_API_ID"])
API_HASH = os.environ["TG_API_HASH"]
SESSION = os.path.expanduser("~/.config/tg-search/session")

# скам / реклама / накрутка — режем
BAD_WORDS = re.compile(
    r"(fixed|fixedmatch|договорн|гарантир|100\s*%|vip\s*fix|"
    r"1xbet|1хбет|winline|betwinner|mostbet|melbet|leon\s*bets|"
    r"промокод|промо\s*код|casino|казино|"
    r"besplatn|бесплатн|"
    r"ставка[_\s]*(futbol|besplatn|sport|stop|start|free|win|go|"
    r"pro|vip|top|max|best|super|plus|ру|ru|ss|yt|54|0|1|2|3|4|5|6|7|8|9)|"
    r"аренда|аккаунт.*минус|минус.*аккаунт|продам.*аккаунт|"
    r"депозит|обнал|обналичк|betboom|бетбум)",
    re.IGNORECASE)

# полезные — поднимаем
GOOD_WORDS = re.compile(
    r"(чат|обсужда|беттор|вилк|арбитраж|value|sharp|"
    r"экспресс|фрибет|bonus|биржа|smarkets|pinnacle|betfair|"
    r"лига\s*ставок|pari|марафон|бк)", re.IGNORECASE)

async def search(query, limit, min_members, max_members, chats_only):
    client = TelegramClient(SESSION, API_ID, API_HASH)
    await client.start()
    try:
        res = await client(SearchRequest(q=query, limit=limit))
        found = []
        for c in res.chats:
            if not isinstance(c, (Channel, Chat)): continue
            is_group = isinstance(c, Chat) or getattr(c, "megagroup", False)
            if chats_only and not is_group: continue
            u = getattr(c, "username", None)
            if not u: continue
            t = getattr(c, "title", "") or ""
            if BAD_WORDS.search(t) or BAD_WORDS.search(u): continue
            m = getattr(c, "participants_count", 0) or 0
            if m < min_members or m > max_members: continue
            s = 1 if GOOD_WORDS.search(t) else 0
            found.append((s, m, u, t, "chat" if is_group else "channel"))
        found.sort(key=lambda x: (-x[0], -x[1]))
        print(f"{'score':>5}  {'members':>8}  {'type':>7}  username  title")
        print("-" * 90)
        for s, m, u, t, k in found:
            print(f"{s:>5}  {m:>8}  {k:>7}  @{u}  {t}")
        print(f"\nНайдено: {len(found)}")
    finally:
        await client.disconnect()

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("query", nargs="+")
    ap.add_argument("--limit", type=int, default=100)
    ap.add_argument("--min-members", type=int, default=300)
    ap.add_argument("--max-members", type=int, default=100000)
    ap.add_argument("--chats-only", action="store_true")
    a = ap.parse_args()
    try:
        asyncio.run(search(" ".join(a.query), a.limit, a.min_members, a.max_members, a.chats_only))
    except KeyError as e:
        print(f"missing env: {e}", file=sys.stderr); sys.exit(2)

if __name__ == "__main__":
    main()
