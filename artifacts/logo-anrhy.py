"""logo.py — Pseudo-graphic ASCII logo for AnRHY.tm.

Generates a large, centered ASCII-art banner suitable for Telegram
HTML parse_mode (using <pre> for monospace block).

The logo is designed to visually fill the chat window width and be
centered within it.
"""

# Large block-letter ASCII art for "AnRHY.tm"
# Each letter is 7 rows tall, using █ ▌ ▐ and space for shading.
# Width ≈ 60 chars — fills a typical Telegram desktop window.

_LOGO_LINES = [
    " █████╗ ██   ██╗███   ███╗██████╗  ██████╗ ██   ██╗██████╗ ",
    "██╔══██╗███  ███║█████ █████║██╔══██╗██╔═══██╗███  ███║██╔══██╗",
    "██║  ██║████ ████║██╔██████╔║██████╔╝██║   ██║████ ████║██████╔╝",
    "██║  ██║██ ██╔███║██║╚██╔╝██║██╔═══╝ ██║   ██║██ ██╔███║██╔══██╗",
    "╚█████╔╝██║╚═╝██║██║ ╚═╝ ██║██║     ╚██████╔╝██║╚═╝██║██████╔╝",
    " ╚════╝ ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝   ╚═╝╚════╝ ",
    "                                                                 ",
    "  ╦═╦═╦  ═╗╔═  ╔╦╗  ╔══╗  ╔═╦═╗  ╔══╗   ╔══╗  ╦═╦  ╔═══╗  ",
    "  ║╔╩╦║   ║║║   ║   ║ ╔╝  ║ ║ ║  ║ ╔╝   ║ ╔╝  ╩═╬═ ║ ╔═╝  ",
    "  ╚╝ ╚╝   ╝╚╝   ╩   ╚═╝   ╩ ╩ ╩  ╚═╝    ╚═╝     ╩  ╚═══╝  ",
]


def get_logo() -> str:
    """Return the ASCII logo as a single string (newline-joined)."""
    return "\n".join(_LOGO_LINES)


def get_logo_html() -> str:
    """Return the logo wrapped in <pre> for Telegram HTML parse_mode.

    The <pre> block renders in monospace, preserving alignment.
    """
    return "<pre>" + get_logo() + "</pre>"


def get_logo_centered(width: int = 60) -> str:
    """Return the logo with each line centered to `width` chars."""
    centered = []
    for line in _LOGO_LINES:
        stripped = line.rstrip()
        pad = max(0, (width - len(stripped)) // 2)
        centered.append(" " * pad + stripped)
    return "\n".join(centered)


def get_logo_html_centered(width: int = 60) -> str:
    """Return centered logo in <pre> for Telegram HTML parse_mode."""
    return "<pre>" + get_logo_centered(width) + "</pre>"
