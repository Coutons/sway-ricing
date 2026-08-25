#!/bin/bash
# Sway autostart - runs after Wayland env is ready

# Wait for Wayland socket
while [ -z "$WAYLAND_DISPLAY" ] || [ ! -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]; do
    sleep 0.2
done

# Wallpaper
swaybg -i ~/Pictures/od_zsh.png -m fill &

# Bar
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &

# Notifications
swaync &

# Idle lock
swayidle -w \
    timeout 300 'swaylock -f -c 1e1e2e --font "JetBrains Mono" --font-size 18' \
    timeout 600 'swaymsg "output * dpms off"' \
    before-sleep 'swaylock -f -c 1e1e2e --font "JetBrains Mono" --font-size 18' &

# Network manager applet (needs XWayland)
nm-applet --indicator &

# Polkit
/usr/libexec/xdg-desktop-portal &
/usr/libexec/xdg-desktop-portal-gtk &

# Update environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway