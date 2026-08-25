#!/bin/bash
# Status command for swaybar - works inside and outside sway

echo '{"version":1}'
echo '['
echo '[],'
while true; do
    # Try to get workspace from sway, fallback to "1"
    if command -v swaymsg >/dev/null 2>&1 && [ -n "$SWAYSOCK" ]; then
        ws=$(swaymsg -t get_workspaces 2>/dev/null | jq -r '.[] | select(.focused==true) | .name' 2>/dev/null)
    fi
    ws=${ws:-1}
    printf '[{"full_text":" %s ","color":"#89b4fa"},{"full_text":" %s ","color":"#cdd6f4"}]\n' "$ws" "$(date '+%H:%M')"
    sleep 1
done