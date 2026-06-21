#!/bin/bash
set -euo pipefail

THEME_SRC="$(cd "$(dirname "$0")" && pwd)"
THEME_NAME="$(basename "$THEME_SRC")"
THEMES_DIR="/usr/share/themes"
THEME_DEST="$THEMES_DIR/$THEME_NAME"

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
GTK4_CONFIG="$REAL_HOME/.config/gtk-4.0"
CONFIG_DIR="$REAL_HOME/.config/flow-shell"

if [ -d "$THEME_DEST" ]; then
  echo "Error: '$THEME_NAME' already exists in $THEMES_DIR"
  echo "Remove it first with: sudo rm -rf $THEME_DEST"
  exit 1
fi

echo "Installing $THEME_NAME to $THEME_DEST..."
sudo cp -r "$THEME_SRC" "$THEMES_DIR/"
sudo chmod -R a+rX "$THEME_DEST"
# Make gnome-shell CSS files writable by the user (for dynamic Top Bar Tweaks)
sudo chmod 666 "$THEME_DEST/gnome-shell/gnome-shell"*.css
echo "  (gnome-shell CSS files set to user-writable for dynamic opacity)"

# Install Top Bar Tweaks app
echo ""
echo "Installing Top Bar Tweaks..."
APP_SRC="$THEME_SRC/topbar-tweaks"
sudo cp "$APP_SRC/topbar-tweaks" /usr/local/bin/topbar-tweaks
sudo chmod 755 /usr/local/bin/topbar-tweaks
sudo cp "$APP_SRC/topbar-tweaks.desktop" /usr/share/applications/

# Copy GTK4 CSS and set theme
mkdir -p "$GTK4_CONFIG"
if [ -f "$THEME_SRC/gtk-4.0/gtk.css" ]; then
  cp "$THEME_SRC/gtk-4.0/gtk.css" "$GTK4_CONFIG/gtk.css"
  echo "Copied GTK4 CSS to $GTK4_CONFIG/gtk.css"
else
  echo "Warning: no gtk-4.0/gtk.css found in theme"
fi

if [ -f "$GTK4_CONFIG/settings.ini" ]; then
  if grep -q "^gtk-theme-name=" "$GTK4_CONFIG/settings.ini"; then
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$THEME_NAME/" "$GTK4_CONFIG/settings.ini"
  else
    echo "gtk-theme-name=$THEME_NAME" >> "$GTK4_CONFIG/settings.ini"
  fi
  echo "Updated gtk-theme-name in settings.ini"
fi

echo ""
echo "Done! Select '$THEME_NAME' in GNOME Tweaks (if needed)."
echo ""
echo "Top Bar Tweaks installed \u2014 launch it from your app grid to customize opacity."
echo "  (opacity applies dynamically as you slide)"
