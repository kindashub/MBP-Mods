#!/bin/bash
# ClearlyEdit: new .md in ~/TextMD, open in ClearlyMD.app (inside ~/MBP-Mods/ClearlyMD/).
# Use /bin/bash (not env) so AppleScript "do shell script" and Dock applets invoke reliably.

set -euo pipefail

FOLDER="${TEXTEDIT_DEFAULT_DIR:-$HOME/TextMD}"
STEM="${TEXTEDIT_PREFIX:-TX}"

mkdir -p "$FOLDER"
WDAY="$(LC_ALL=C date +%a | tr '[:lower:]' '[:upper:]')"
FILENAME="${FOLDER}/${STEM}-${WDAY}$(date +%Y%m%d)-$(date +%H%M%S).md"
touch "$FILENAME"

APP="${CLEARLYMD_APP:-$HOME/MBP-Mods/ClearlyMD/ClearlyMD.app}"
if [[ -d "$APP" ]]; then
  open -a "$APP" "$FILENAME"
else
  open -b com.clearlymd.editor "$FILENAME"
fi
