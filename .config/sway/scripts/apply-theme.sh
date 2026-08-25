#!/bin/bash
# Generate themed configs from palette.env (Ryoku-style wallpaper theming)
set -e
PAL="$HOME/.config/sway/palette.env"
TPL="$HOME/.config/sway/templates"
# Fallback = Ryoku vermillion default
[ -f "$PAL" ] && . "$PAL"
BG="${BG:-242830}"; SURF="${SURF:-27292c}"; TXT="${TXT:-c0bbbf}"; MUT="${MUT:-8b8b91}"
ACC="${ACC:-e2342a}"; ACC2="${ACC2:-ff4638}"; URG="${URG:-d9a441}"

render() {
  sed -e "s/@BG@/$BG/g"   -e "s/@SURF@/$SURF/g" -e "s/@TXT@/$TXT/g" \
      -e "s/@MUT@/$MUT/g" -e "s/@ACC@/$ACC/g"   -e "s/@ACC2@/$ACC2/g" \
      -e "s/@URG@/$URG/g" "$1" > "$2"
}

render "$TPL/waybar.css.tmpl"      "$HOME/.config/waybar/style.css"
render "$TPL/fuzzel.ini.tmpl"      "$HOME/.config/fuzzel/fuzzel.ini"
render "$TPL/swaylock.conf.tmpl"   "$HOME/.config/swaylock/config"
render "$TPL/sway-theme.conf.tmpl" "$HOME/.config/sway/config.d/theme.conf"

# Sinkronkan wallpaper gtklock jika ada info WALL
[ -n "$WALL" ] && sed -i "s|^background=.*|background=$WALL|" "$HOME/.config/gtklock/config.ini"

echo "theme applied: BG=#$BG ACC=#$ACC"