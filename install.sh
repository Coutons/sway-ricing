#!/usr/bin/env bash
# Install Fedora Sway Rice dotfiles dari repo ini ke $HOME
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Repo: $REPO_DIR"
echo "Target: $HOME"

# .config
[ -d "$REPO_DIR/.config" ] && cp -r "$REPO_DIR/.config/"* "$HOME/.config/" 2>/dev/null || true
# .local
[ -d "$REPO_DIR/.local" ] && cp -r "$REPO_DIR/.local/"* "$HOME/.local/" 2>/dev/null || true

chmod +x "$HOME/.local/bin/fedora-"* "$HOME/.local/bin/power-menu" 2>/dev/null || true
chmod +x "$HOME/.config/waybar/scripts/"* 2>/dev/null || true

echo "Selesai. Jalankan ulang waybar + sway:"
echo "  pkill -x waybar; waybar &"
echo "  swaymsg reload  # atau log out/in untuk sesi penuh"
