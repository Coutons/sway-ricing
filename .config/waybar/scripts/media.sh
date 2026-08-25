#!/usr/bin/env bash
# Media pill: indikasi lagu yang sedang diputar
title=$(playerctl metadata title 2>/dev/null)
[ -z "$title" ] && exit 0
artist=$(playerctl metadata artist 2>/dev/null)
status=$(playerctl status 2>/dev/null)
icon=$'\uf04b'
[ "$status" = "Paused" ] && icon=$'\uf04c'
python3 - "$icon" "$artist" "$title" <<'PYEOF'
import json, sys
icon, artist, title = sys.argv[1:4]
body = f"{artist} — {title}" if artist else title
text = f"<span font_family='Font Awesome 6 Free Solid' size='9pt'>{icon}</span>  {body}"
print(json.dumps({"text": text, "class": "media"}))
PYEOF
