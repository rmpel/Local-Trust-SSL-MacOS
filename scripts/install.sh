#!/usr/bin/env bash

###
# Package: Trust SSL — macOS Fix - Make Local's "Trust" SSL button actually work on macOS.
# Version: see package.json
# License: see README.md and LICENSE
# Author: Remon Pel
###

# Installs the add-on into Local by symlinking this folder into Local's addons
# directory and installing its dependencies.
set -euo pipefail

ADDON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ "$(uname -s)" != "Darwin" ]; then
	echo "This add-on fixes a macOS-specific issue in Local and only runs on macOS." >&2
	exit 1
fi

ADDONS_ROOT="$HOME/Library/Application Support/Local/addons"

echo "Installing dependencies…"
cd "$ADDON_DIR"
npm install --no-audit --no-fund

echo "Building…"
npm run build

mkdir -p "$ADDONS_ROOT"
LINK="$ADDONS_ROOT/local-trust-ssl-macos"
if [ -e "$LINK" ] && [ ! -L "$LINK" ]; then
	echo "ERROR: $LINK already exists and is not a symlink — remove it first." >&2
	exit 1
fi
ln -sfn "$ADDON_DIR" "$LINK"

echo
echo "Linked: $LINK -> $ADDON_DIR"
echo "Now restart Local, open Add-ons -> Installed, enable 'Trust SSL — macOS Fix', and relaunch."
