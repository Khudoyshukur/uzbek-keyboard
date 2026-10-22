#!/bin/sh
# Install the Uzbek Keyboard XKB layout.
#   ./install.sh            current user only (~/.config/xkb, works on Wayland: GNOME, KDE, Sway...)
#   sudo ./install.sh --system   all users (/usr/share/X11/xkb, needed for X11 sessions)
#   ./install.sh --uninstall [--system]
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
NAME=uzbekkb

SYSTEM=0; UNINSTALL=0
for arg in "$@"; do
  case "$arg" in
    --system) SYSTEM=1 ;;
    --uninstall) UNINSTALL=1 ;;
    *) echo "unknown option: $arg"; exit 2 ;;
  esac
done

if [ "$SYSTEM" = 1 ]; then
  DEST=/usr/share/X11/xkb
else
  DEST="${XDG_CONFIG_HOME:-$HOME/.config}/xkb"
fi

if [ "$UNINSTALL" = 1 ]; then
  rm -f "$DEST/symbols/$NAME"
  if [ "$SYSTEM" = 0 ] && grep -q "<name>$NAME</name>" "$DEST/rules/evdev.xml" 2>/dev/null; then
    rm -f "$DEST/rules/evdev.xml"
  fi
  echo "Removed $NAME from $DEST"
  exit 0
fi

mkdir -p "$DEST/symbols"
cp "$HERE/xkb/symbols/$NAME" "$DEST/symbols/$NAME"
echo "Installed $DEST/symbols/$NAME"

if [ "$SYSTEM" = 0 ]; then
  # Lets layout pickers (libxkbregistry) list "Uzbek Keyboard"
  mkdir -p "$DEST/rules"
  if [ -e "$DEST/rules/evdev.xml" ] && ! grep -q "<name>$NAME</name>" "$DEST/rules/evdev.xml"; then
    echo "Note: $DEST/rules/evdev.xml already exists; not touching it."
    echo "Merge the <layout> entry from $HERE/xkb/rules/evdev.xml into it by hand."
  else
    cp "$HERE/xkb/rules/evdev.xml" "$DEST/rules/evdev.xml"
    echo "Installed $DEST/rules/evdev.xml"
  fi
fi

cat <<EOF

Next steps:
  GNOME:  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', '$NAME')]"
          (then log out and back in)
  KDE:    System Settings > Keyboard > Layouts > Add > "Uzbek Keyboard"
  X11:    setxkbmap $NAME        (needs --system install)
  Sway:   input * xkb_layout $NAME
EOF
