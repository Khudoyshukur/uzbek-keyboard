#!/bin/sh
# Özbekça klaviatura (Uzbek Latin) - Linux installer.
#   Install (current user, Wayland):  curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/linux/install.sh | sh
#   Install (all users, X11 too):     curl -fsSL .../linux/install.sh | sudo sh -s -- --system
#   Remove:                           curl -fsSL .../linux/install.sh | sh -s -- --uninstall   (add --system if installed so)
set -eu
REPO=khudoyshukur/uzbek-keyboard
NAME=uzbekkb

SYSTEM=0; UNINSTALL=0
for arg in "$@"; do
  case "$arg" in
    --system) SYSTEM=1 ;;
    --uninstall) UNINSTALL=1 ;;
    *) echo "Nomaʼlum parametr: $arg"; exit 2 ;;
  esac
done

if [ "$SYSTEM" = 1 ]; then
  DEST=/usr/share/X11/xkb
else
  DEST="${XDG_CONFIG_HOME:-$HOME/.config}/xkb"
fi

gnome_sources() { gsettings get org.gnome.desktop.input-sources sources 2>/dev/null; }

if [ "$UNINSTALL" = 1 ]; then
  rm -f "$DEST/symbols/$NAME"
  if [ "$SYSTEM" = 0 ] && grep -q "<name>$NAME</name>" "$DEST/rules/evdev.xml" 2>/dev/null; then
    rm -f "$DEST/rules/evdev.xml"
  fi
  if cur=$(gnome_sources) && echo "$cur" | grep -q "'$NAME'"; then
    new=$(echo "$cur" | sed "s/, ('xkb', '$NAME')//; s/('xkb', '$NAME'), //; s/('xkb', '$NAME')//")
    gsettings set org.gnome.desktop.input-sources sources "$new"
  fi
  echo "✓ Öçirildi. Tizimdan çiqib qayta kiring."
  exit 0
fi

# Use the files next to this script, or download the latest release
HERE=$(cd "$(dirname "$0")" 2>/dev/null && pwd || echo .)
if [ ! -f "$HERE/xkb/symbols/$NAME" ]; then
  TMP=$(mktemp -d)
  trap 'rm -rf "$TMP"' EXIT
  curl -fsSL "https://github.com/$REPO/releases/latest/download/UzbekKeyboard-Linux.tar.gz" | tar -xz -C "$TMP"
  HERE="$TMP/UzbekKeyboard-Linux"
  echo "✓ Yuklab olindi"
fi

mkdir -p "$DEST/symbols"
cp "$HERE/xkb/symbols/$NAME" "$DEST/symbols/$NAME"
echo "✓ Örnatildi: $DEST/symbols/$NAME"

if [ "$SYSTEM" = 0 ]; then
  # Lets layout pickers (libxkbregistry) list "Uzbek Latin"
  mkdir -p "$DEST/rules"
  if [ -e "$DEST/rules/evdev.xml" ] && ! grep -q "<name>$NAME</name>" "$DEST/rules/evdev.xml"; then
    echo "! $DEST/rules/evdev.xml allaqaçon bor; unga $HERE/xkb/rules/evdev.xml dagi <layout> ni qölda qöşing."
  else
    cp "$HERE/xkb/rules/evdev.xml" "$DEST/rules/evdev.xml"
  fi
  # GNOME: append to the user's layouts (keeps the existing ones)
  if cur=$(gnome_sources); then
    if ! echo "$cur" | grep -q "'$NAME'"; then
      case "$cur" in
        *"[]"*) new="[('xkb', 'us'), ('xkb', '$NAME')]" ;;
        *) new=$(echo "$cur" | sed "s/]\$/, ('xkb', '$NAME')]/") ;;
      esac
      gsettings set org.gnome.desktop.input-sources sources "$new"
    fi
    echo "✓ GNOME klaviaturalari röyxatiga qöşildi"
  fi
fi

cat <<EOF

Tizimdan çiqib qayta kiring, keyin "Uzbek Latin" ni tanlang.
  AltGr (öng Alt) + o → ö   g → ğ   s → ş   c → ç   ' → ʼ   (Shift bilan — katta harf)

GNOME bölmasa:
  KDE Plasma:  System Settings → Keyboard → Layouts → Add → Uzbek Latin
  Sway:        input * xkb_layout "us,$NAME"
  X11 (Xorg):  sudo bilan --system örnating, keyin: setxkbmap $NAME
EOF
