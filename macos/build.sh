#!/bin/bash
# Package the macOS bundle as a .zip and an installer .pkg into dist/.
#
# Optional signing + notarization of the .pkg (unsigned when not set):
#   PKG_SIGN_IDENTITY  e.g. "Developer ID Installer: Name (TEAMID)"
#   NOTARY_PROFILE     a `xcrun notarytool store-credentials` profile, or
#   APPLE_ID + APPLE_APP_PASSWORD + APPLE_TEAM_ID
set -euo pipefail
export COPYFILE_DISABLE=1   # keep macOS ._ metadata files out of the archives
cd "$(dirname "$0")/.."

VERSION=$(cat VERSION)
BUNDLE_ID=io.github.khudoyshukur.keyboardlayout.uzbek
OUT=dist
mkdir -p "$OUT"

STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
cp -R macos/UzbekKeyboard.bundle "$STAGE/"

# Zip for manual install (drag into ~/Library/Keyboard Layouts)
(cd "$STAGE" && ditto -c -k --norsrc --noextattr --keepParent UzbekKeyboard.bundle "UzbekKeyboard-macOS-$VERSION.zip")
mv "$STAGE/UzbekKeyboard-macOS-$VERSION.zip" "$OUT/"

# Installer package -> /Library/Keyboard Layouts (all users)
ROOT_DIR="$STAGE/root"
mkdir -p "$ROOT_DIR"
mv "$STAGE/UzbekKeyboard.bundle" "$ROOT_DIR/"
pkgbuild --analyze --root "$ROOT_DIR" "$STAGE/component.plist" >/dev/null
plutil -replace 0.BundleIsRelocatable -bool NO "$STAGE/component.plist"
SIGN=()
[ -n "${PKG_SIGN_IDENTITY:-}" ] && SIGN=(--sign "$PKG_SIGN_IDENTITY")
pkgbuild --quiet ${SIGN[@]+"${SIGN[@]}"} \
  --root "$ROOT_DIR" \
  --component-plist "$STAGE/component.plist" \
  --identifier "$BUNDLE_ID" \
  --version "$VERSION" \
  --install-location "/Library/Keyboard Layouts" \
  --scripts macos/pkg-scripts \
  "$OUT/UzbekKeyboard-macOS-$VERSION.pkg"

PKG="$OUT/UzbekKeyboard-macOS-$VERSION.pkg"
if [ -n "${PKG_SIGN_IDENTITY:-}" ]; then
  if [ -n "${NOTARY_PROFILE:-}" ]; then
    AUTH=(--keychain-profile "$NOTARY_PROFILE")
  elif [ -n "${APPLE_ID:-}" ]; then
    AUTH=(--apple-id "$APPLE_ID" --password "$APPLE_APP_PASSWORD" --team-id "$APPLE_TEAM_ID")
  fi
  if [ -n "${AUTH+x}" ]; then
    xcrun notarytool submit "$PKG" "${AUTH[@]}" --wait | tee "$STAGE/notary.log"
    grep -q "status: Accepted" "$STAGE/notary.log"
    xcrun stapler staple "$PKG"
  fi
  spctl -a -vv -t install "$PKG"
fi

ls -l "$OUT"
