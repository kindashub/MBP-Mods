#!/usr/bin/env bash
# Create a new Markdown file in the default TextEdit folder and open it in TextEdit.
# Cmd+S saves in place (no folder picker) because the file already exists on disk.
#
# Environment:
#   TEXTEDIT_DEFAULT_DIR — folder for new files (default: $HOME/TextMD)
#   TEXTEDIT_PREFIX      — first segment (default: TX), e.g. TX-MON20260406-094222.md
#
# Note: colons in filenames are shown as "/" in Finder (legacy macOS); use hyphens so names display as intended.

set -euo pipefail

FOLDER="${TEXTEDIT_DEFAULT_DIR:-$HOME/TextMD}"
STEM="${TEXTEDIT_PREFIX:-TX}"

mkdir -p "$FOLDER"
# English weekday (MON…SUN) so names match regardless of system locale
WDAY="$(LC_ALL=C date +%a | tr '[:lower:]' '[:upper:]')"
FILENAME="${FOLDER}/${STEM}-${WDAY}$(date +%Y%m%d)-$(date +%H%M%S).md"
touch "$FILENAME"
open -a TextEdit "$FILENAME"
