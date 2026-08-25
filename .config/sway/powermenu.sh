#!/usr/bin/env bash
# Power menu for Sway using wofi

CHOICE=$(printf " Lock\n Logout\n Reboot\n Shutdown\n Suspend\n Hibernate" | wofi --dmenu --prompt "Power" --width 250 --height 300 --lines 6)

case "$CHOICE" in
    " Lock")
        swaylock -f -c 1e1e2e --font "JetBrains Mono" --font-size 18
        ;;
    " Logout")
        swaymsg exit
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Shutdown")
        systemctl poweroff
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Hibernate")
        systemctl hibernate
        ;;
esac