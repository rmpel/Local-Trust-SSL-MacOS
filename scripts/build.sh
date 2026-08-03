#!/usr/bin/env bash

###
# Package: Trust SSL — macOS Fix - Make Local's "Trust" SSL button actually work on macOS.
# Version: see package.json
# License: see README.md and LICENSE
# Author: Remon Pel
###

#
# build.sh — package the add-on as a distributable Local (LocalWP) add-on.
#
# Local add-ons ship as a folder that the user drops into Local's addons
# directory. This add-on has no runtime dependencies, so the folder is just
# the compiled lib/, the sources, and the package metadata, zipped to
# dist/<slug>-v<version>.zip with a single top-level folder named after the
# package (the same name install.sh symlinks).
#
set -euo pipefail

cd "$(dirname "$0")"/.. || exit 1
ROOT=$(pwd -P)

# --- read identity from package.json (node is guaranteed present here) --------
NAME="$(node -p "require('./package.json').name")"
VERSION="$(node -p "require('./package.json').version")"
PRODUCT="$(node -p "require('./package.json').productName || require('./package.json').name")"

STAGE="$ROOT/build"
PKG_DIR="$STAGE/$NAME"
DIST="$ROOT/dist"
ZIP="$DIST/${NAME}-v${VERSION}.tgz"

echo "==> Building $PRODUCT v$VERSION"

# --- compile ------------------------------------------------------------------
echo "==> Compiling TypeScript"
npm install
npm run build

# --- clean --------------------------------------------------------------------
rm -rf "$STAGE" "$ZIP"
mkdir -p "$PKG_DIR" "$DIST"

# --- stage the files that ship in the add-on ----------------------------------
echo "==> Staging files"
cp -R lib src "$PKG_DIR/"
cp package.json icon.svg README.md LICENSE "$PKG_DIR/"

if [ -d scripts ]; then
	cp -R scripts "$PKG_DIR/"
fi

# --- zip (archive contains a single top-level "<name>/" folder) ---------------
echo "==> Creating archive"
(
	cd "$STAGE"
	tar --exclude='.DS_Store' --exclude='.git' --exclude='npm-debug.log' -zcf "$ZIP" "$NAME"
)

SIZE="$(du -h "$ZIP" | cut -f1)"
echo
echo "==> Done: $ZIP  ($SIZE)"
echo "    Install: In LocalWP Select install from disk, then select the .tgz file"
echo "    and enable '$PRODUCT' under Add-ons -> Installed."
