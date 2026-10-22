#!/bin/bash
# Package the macOS bundle as a .zip and an installer .pkg into dist/.
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
pkgbuild --quiet \
  --root "$ROOT_DIR" \
  --component-plist "$STAGE/component.plist" \
  --identifier "$BUNDLE_ID" \
  --version "$VERSION" \
  --install-location "/Library/Keyboard Layouts" \
  "$OUT/UzbekKeyboard-macOS-$VERSION.pkg"

ls -l "$OUT"
