#!/bin/bash
# Özbekça klaviatura (Uzbek Latin) - macOS installer. No admin rights needed.
#   Install:   curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash
#   Remove:    curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash -s -- --uninstall
set -euo pipefail

REPO="khudoyshukur/uzbek-keyboard"
BUNDLE="UzbekKeyboard.bundle"
USER_DIR="$HOME/Library/Keyboard Layouts"
SYS_DIR="/Library/Keyboard Layouts"

say()  { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }

SOURCE_ID="io.github.khudoyshukur.keyboardlayout.uzbek.uzbekkeyboard"

# Talk to macOS's input-source service (the same API System Settings uses).
# Writing com.apple.HIToolbox prefs directly gets out of sync with the running
# service and makes System Settings list the layout many times.
#   tis register <bundle path> | tis enable | tis disable
tis() {
  osascript -l JavaScript - "$@" <<'JS'
function run(argv) {
  ObjC.import("Carbon");
  ObjC.bindFunction("TISCreateInputSourceList", ["void *", ["id", "bool"]]);
  ObjC.bindFunction("TISRegisterInputSource", ["int", ["id"]]);
  ObjC.bindFunction("TISEnableInputSource", ["int", ["void *"]]);
  ObjC.bindFunction("TISDisableInputSource", ["int", ["void *"]]);
  ObjC.bindFunction("CFArrayGetCount", ["long", ["void *"]]);
  ObjC.bindFunction("CFArrayGetValueAtIndex", ["void *", ["void *", "long"]]);
  var action = argv[0];
  if (action === "register") return String($.TISRegisterInputSource($.NSURL.fileURLWithPath(argv[1])));
  function find(all) {
    var l = $.TISCreateInputSourceList(
      $.NSDictionary.dictionaryWithObjectForKey(argv[1], "TISPropertyInputSourceID"), all);
    var out = [];
    if (l) for (var i = 0, n = $.CFArrayGetCount(l); i < n; i++) out.push($.CFArrayGetValueAtIndex(l, i));
    return out;
  }
  var on = find(false);  // only enabled sources
  if (action === "enable" && on.length === 0) {
    var all = find(true);
    if (all.length) $.TISEnableInputSource(all[0]);
  }
  if (action === "disable") on.forEach(function (x) { $.TISDisableInputSource(x); });
  return String(find(false).length);  // how many are enabled now
}
JS
}

enable_layout() {
  tis register "$USER_DIR/$BUNDLE" >/dev/null 2>&1 || true
  if [ "$(tis enable "$SOURCE_ID" 2>/dev/null)" != 0 ]; then
    ok "Klaviaturalar röyxatiga qöşildi"
  else
    say "Klaviaturani qölda qöşing: System Settings → Keyboard → Text Input → Edit… → + → Uzbek Latin"
  fi
}

disable_layout() {
  tis disable "$SOURCE_ID" >/dev/null 2>&1 || true
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

cat <<'EOF'

Qayta kirganingizdan söng fn / 🌐 tugmasi bilan "UZ" klaviaturasini tanlang:
  ⌥ o → ö   ⌥ g → ğ   ⌥ s → ş   ⌥ c → ç   ⌥ ' → ʼ   (⇧ bilan — katta harf)
EOF
offer_logout
