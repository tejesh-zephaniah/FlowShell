#!/bin/bash
set -euo pipefail

THEME_SRC="$(cd "$(dirname "$0")" && pwd)"
THEME_NAME="$(basename "$THEME_SRC")"
THEMES_DIR="/usr/share/themes"
THEME_DEST="$THEMES_DIR/$THEME_NAME"

if [ -d "$THEME_DEST" ]; then
  echo "Error: '$THEME_NAME' already exists in $THEMES_DIR"
  echo "Remove it first with: sudo rm -rf $THEME_DEST"
  exit 1
fi

echo "Installing $THEME_NAME to $THEME_DEST..."
sudo cp -r "$THEME_SRC" "$THEMES_DIR/"
sudo chmod -R a+rX "$THEME_DEST"

echo "Done. Select '$THEME_NAME' using GNOME Tweaks or gnome-shell-extension-manager."
