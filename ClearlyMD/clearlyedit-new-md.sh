#!/usr/bin/env bash
# ClearlyEdit: create a new Markdown file in ~/TextMD (or TEXTEDIT_DEFAULT_DIR) and open it in ClearlyMD.
#
# Environment:
#   TEXTEDIT_DEFAULT_DIR — folder for new files (default: $HOME/TextMD)
#   TEXTEDIT_PREFIX      — first segment (default: TX)
#   CLEARLYMD_APP        — override path to ClearlyMD.app (optional)

set -euo pipefail

FOLDER="${TEXTEDIT_DEFAULT_DIR:-$HOME/TextMD}"
STEM="${TEXTEDIT_PREFIX:-TX}"

mkdir -p "$FOLDER"
WDAY="$(LC_ALL=C date +%a | tr '[:lower:]' '[:upper:]')"
FILENAME="${FOLDER}/${STEM}-${WDAY}$(date +%Y%m%d)-$(date +%H%M%S).md"
touch "$FILENAME"

APP="${CLEARLYMD_APP:-$HOME/MBP-Mods/ClearlyMD.app}"
if [[ -d "$APP" ]]; then
  open -a "$APP" "$FILENAME"
else
  open -b com.clearlymd.editor "$FILENAME"
fi
