#!/bin/bash
# Uninstall FlowShell theme and Top Bar Tweaks app
set -euo pipefail

THEME_DIR="/usr/share/themes/FlowShell"
APP_BIN="/usr/local/bin/topbar-tweaks"
DESKTOP_FILE="/usr/share/applications/topbar-tweaks.desktop"
HELPER_SCRIPT="/usr/local/share/flow-shell/apply-opacity.sh"
HELPER_DIR="/usr/local/share/flow-shell"
CONFIG_DIR="$HOME/.config/flow-shell"
GTK4_CONFIG="$HOME/.config/gtk-4.0"

echo "This will remove FlowShell and Top Bar Tweaks."
read -p "Continue? [y/N] " confirm
if [[ "$confirm" != [yY] ]]; then
    echo "Cancelled."
    exit 1
fi

# Remove theme
if [ -d "$THEME_DIR" ]; then
    echo "Removing $THEME_DIR..."
    sudo rm -rf "$THEME_DIR"
fi

# Remove app
if [ -f "$APP_BIN" ]; then
    echo "Removing $APP_BIN..."  
    sudo rm -f "$APP_BIN"
fi

if [ -f "$DESKTOP_FILE" ]; then
    echo "Removing $DESKTOP_FILE..."
    sudo rm -f "$DESKTOP_FILE"
fi

if [ -d "$HELPER_DIR" ]; then
    echo "Removing $HELPER_DIR..."  
    sudo rm -rf "$HELPER_DIR"
fi

# Remove config
if [ -f "$GTK4_CONFIG/gtk.css" ]; then
    echo "Removing GTK4 user CSS..."
    rm -f "$GTK4_CONFIG/gtk.css"
fi

if [ -f "$GTK4_CONFIG/settings.ini" ]; then
    echo "Resetting gtk-theme-name in settings.ini..."
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=Breeze/" "$GTK4_CONFIG/settings.ini"
fi

if [ -f "$CONFIG_DIR/topbar-opacity.conf" ]; then
    echo "Removing flow-shell config..."
    rm -rf "$CONFIG_DIR"
fi

echo ""
echo "FlowShell uninstalled. Restart the Shell (Alt+F2, r, Enter) to apply default theme."
