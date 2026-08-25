#!/usr/bin/env bash
# Satu pill sistem: CPU + RAM
read -r _ a b c d e f g h _ < /proc/stat
busy1=$((a+b+c+f+g+h)); total1=$((a+b+c+d+e+f+g+h))
sleep 0.4
read -r _ a b c d e f g h _ < /proc/stat
busy2=$((a+b+c+f+g+h)); total2=$((a+b+c+d+e+f+g+h))
cpu=$(( 100 * (busy2-busy1) / (total2-total1) ))
ram=$(free -m | awk '/^Mem/{printf "%d", $3/$2*100}')
temp=""
for d in /sys/class/hwmon/hwmon*; do
  [ "$(cat "$d/name" 2>/dev/null)" = k10temp ] && temp=$(( $(cat "$d/temp1_input") / 1000 )) && break
done
cls="sys"
[ -n "$temp" ] && [ "$temp" -ge 80 ] && cls="sys hot"
python3 - "$cpu" "$ram" "${temp:--}" "$cls" <<'PYEOF'
import json, sys
cpu, ram, temp, cls = sys.argv[1:5]
temp_part = f"<span font_family='Font Awesome 6 Free Solid' size='9pt'>\uf2c9</span> {temp}°" if temp != "-" else ""
text = (f"<span font_family='Font Awesome 6 Free Solid' size='9pt'>\uf2db</span> {cpu}%"
        f"<span font_family='Font Awesome 6 Free Solid' size='9pt'>   \uefc5</span> {ram}%"
        f"  {temp_part}")
print(json.dumps({"text": text, "class": cls}))
PYEOF
