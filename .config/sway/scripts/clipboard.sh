#!/usr/bin/env bash
# Clipboard history for Waybar/Sway using cliphist

CLIPHIST_DB="$HOME/.cache/cliphist/db"

# Ensure cliphist is running
if ! pgrep -x cliphist >/dev/null; then
    cliphist listen &
    sleep 0.5
fi

case "$1" in
    --menu)
        # Show clipboard menu via wofi
        cliphist list | wofi --dmenu --prompt "Clipboard" --width 600 --height 400 | cliphist decode | wl-copy
        ;;
    *)
        # Output count for waybar
        count=$(cliphist list 2>/dev/null | wc -l)
        echo " CLIP $count "
        ;;
esac