#!/bin/bash
# Özbekça klaviatura (Uzbek Latin) - macOS installer. No admin rights needed.
#   Install:   curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash
#   Remove:    curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash -s -- --uninstall
set -euo pipefail

REPO="khudoyshukur/uzbek-keyboard"
BUNDLE="UzbekKeyboard.bundle"
LAYOUT_NAME="Uzbek Keyboard"   # internal name from the .keylayout; users see "Uzbek Latin"
LAYOUT_ID=-19443
USER_DIR="$HOME/Library/Keyboard Layouts"
SYS_DIR="/Library/Keyboard Layouts"

say()  { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }

# Add the layout to the user's enabled input sources, so it is in the fn/🌐
# switcher right after the next login (macOS only loads new layouts at login).
enable_layout() {
  local current
  current=$(defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null || true)
  if [ -z "$current" ]; then
    say "Klaviaturani qölda qöşing: System Settings → Keyboard → Text Input → Edit… → + → Uzbek Latin"
    return
  fi
  # Drop any old entries first so reinstalling never leaves duplicates.
  remove_entries
  defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
    "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>$LAYOUT_ID</integer><key>KeyboardLayout Name</key><string>$LAYOUT_NAME</string></dict>"
  ok "Klaviaturalar röyxatiga qöşildi"
}

# macOS caches the list of layouts; a stale cache shows the layout many times
# in System Settings after a reinstall. It is rebuilt automatically at login.
clear_cache() {
  local c
  c=$(getconf DARWIN_USER_CACHE_DIR 2>/dev/null) || return 0
  rm -f "${c}com.apple.IntlDataCache.le" "${c}com.apple.IntlDataCache.le.kbdx"
  rm -rf "${c}com.apple.Keyboard-Settings.extension"
}

remove_entries() {
  local f key i
  f=$(mktemp)
  defaults export com.apple.HIToolbox "$f" 2>/dev/null || { rm -f "$f"; return; }
  for key in AppleEnabledInputSources AppleSelectedInputSources AppleInputSourceHistory; do
    i=0
    while /usr/libexec/PlistBuddy -c "Print :$key:$i" "$f" >/dev/null 2>&1; do
      if [ "$(/usr/libexec/PlistBuddy -c "Print :$key:$i:KeyboardLayout\ Name" "$f" 2>/dev/null)" = "$LAYOUT_NAME" ]; then
        /usr/libexec/PlistBuddy -c "Delete :$key:$i" "$f"
      else
        i=$((i + 1))
      fi
    done
  done
  defaults import com.apple.HIToolbox "$f"
  rm -f "$f"
}

disable_layout() {
  remove_entries
  ok "Klaviaturalar röyxatidan olib taşlandi"
}

remove_system_copy() {
  # Left over from the .pkg installer; keep only one copy.
  if [ -d "$SYS_DIR/$BUNDLE" ]; then
    say "$SYS_DIR içidagi nusxa öçirilmoqda (Mac parolingiz söraladi)..."
    sudo rm -rf "$SYS_DIR/$BUNDLE" && ok "Öçirildi: $SYS_DIR/$BUNDLE"
  fi
}

offer_logout() {
  printf '\nÖzgarişlar kuçga kiriši uçun tizimdan çiqib, qayta kiriş kerak.\nHozir çiqasizmi? [ha/yöq]: '
  local ans=""
  read -r ans </dev/tty 2>/dev/null || true
  case "$ans" in
    h|H|ha|Ha|HA|y|Y|yes)
      osascript -e 'tell application "System Events" to log out' >/dev/null 2>&1 \
        || say "Apple menyusi  → Log Out orqali çiqing." ;;
    *)
      echo; say "Keyinroq çiqib qayta kiring:  → Log Out" ;;
  esac
}

if [ "${1:-}" = "--uninstall" ]; then
  say "Özbekça klaviatura öçirilmoqda..."
  disable_layout
  rm -rf "$USER_DIR/$BUNDLE" && ok "Öçirildi: $USER_DIR/$BUNDLE"
  remove_system_copy
  clear_cache
  offer_logout
  exit 0
fi

say "Özbekça klaviatura (Uzbek Latin) örnatilmoqda..."

here=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)
if [ -n "$here" ] && [ -d "$here/$BUNDLE" ]; then
  src="$here/$BUNDLE"
else
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL "https://github.com/$REPO/releases/latest/download/UzbekKeyboard-macOS.zip" -o "$tmp/k.zip"
  ditto -x -k "$tmp/k.zip" "$tmp"
  src="$tmp/$BUNDLE"
  ok "Yuklab olindi"
fi

mkdir -p "$USER_DIR"
rm -rf "${USER_DIR:?}/$BUNDLE"
cp -R "$src" "$USER_DIR/"
xattr -dr com.apple.quarantine "$USER_DIR/$BUNDLE" 2>/dev/null || true
ok "Örnatildi: $USER_DIR/$BUNDLE"
remove_system_copy
enable_layout
clear_cache

cat <<'EOF'

Qayta kirganingizdan söng fn / 🌐 tugmasi bilan "UZ" klaviaturasini tanlang:
  ⌥ o → ö   ⌥ g → ğ   ⌥ s → ş   ⌥ c → ç   ⌥ ' → ʼ   (⇧ bilan — katta harf)
EOF
offer_logout
