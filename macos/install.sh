#!/bin/bash
# Install the layout for the current user only (no admin rights needed).
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)/UzbekKeyboard.bundle"
DEST="$HOME/Library/Keyboard Layouts"
mkdir -p "$DEST"
rm -rf "$DEST/UzbekKeyboard.bundle"
cp -R "$SRC" "$DEST/"
echo "Installed to $DEST/UzbekKeyboard.bundle"
echo "Log out and back in, then add it in System Settings > Keyboard > Text Input > Edit > + > Uzbek."
