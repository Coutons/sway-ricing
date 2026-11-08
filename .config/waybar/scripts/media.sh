#!/usr/bin/env bash
# Media pill — Fedora Sway Rice (playerctl)
set -euo pipefail

title=$(playerctl metadata title 2>/dev/null || true)
[ -z "${title:-}" ] && exit 0

artist=$(playerctl metadata artist 2>/dev/null || true)
status=$(playerctl status 2>/dev/null || true)
if [ "$status" = "Paused" ]; then
  icon="❚❚"
else
  icon="♪"
fi

body="${artist:+$artist — }$title"
printf '{"text": "%s %s", "class": "media", "tooltip": "%s"}\n' "$icon" "$body" "$body"
