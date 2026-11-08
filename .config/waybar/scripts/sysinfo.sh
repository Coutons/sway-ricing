#!/usr/bin/env bash
# CPU + RAM + suhu (jika ada k10temp) — JSON untuk waybar
set -euo pipefail

read -r _ a b c d e f g h _ < /proc/stat
busy1=$((a+b+c+f+g+h)); total1=$((a+b+c+d+e+f+g+h))
sleep 0.4
read -r _ a b c d e f g h _ < /proc/stat
busy2=$((a+b+c+f+g+h)); total2=$((a+b+c+d+e+f+g+h))
if (( total2 > total1 )); then
  cpu=$(( 100 * (busy2 - busy1) / (total2 - total1) ))
else
  cpu=0
fi
ram=$(free -m | awk '/^Mem/{printf "%d", $3/$2*100}')
temp=""
for d in /sys/class/hwmon/hwmon*; do
  name=$(cat "$d/name" 2>/dev/null || true)
  if [ "$name" = k10temp ] || [ "$name" = k8temp ]; then
    t=$(cat "$d/temp1_input" 2>/dev/null || true)
    [ -n "$t" ] && temp=$(( t / 1000 )) && break
  fi
done
if [ -n "$temp" ]; then
  text="⚡${cpu}%  RAM ${ram}%  ${temp}C"
else
  text="⚡${cpu}%  RAM ${ram}%"
fi
cls="sys"
[ -n "$temp" ] && [ "$temp" -ge 80 ] && cls="sys hot"
printf '{"text": "%s", "class": "%s", "tooltip": "CPU %s%% · RAM %s%%%s"}\n' "$text" "$cls" "$cpu" "$ram" "${temp:+ · ${temp}C}"
