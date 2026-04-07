#!/bin/bash
# Print ClearlyMD.app bundle ID; exit 1 if old org.kindashub.* build (reinstall required).

set -euo pipefail

APP="${HOME}/MBP-Mods/ClearlyMD/ClearlyMD.app"
if [[ ! -d "$APP" ]]; then
  echo "error: missing ${APP}" >&2
  echo "Run: ./scripts/install-clearlymd.sh" >&2
  exit 1
fi

BID="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP/Contents/Info.plist" 2>/dev/null || defaults read "$APP/Contents/Info" CFBundleIdentifier 2>/dev/null || echo "")"
if [[ -z "$BID" ]]; then
  echo "error: could not read CFBundleIdentifier from ${APP}/Contents/Info.plist" >&2
  exit 2
fi
echo "ClearlyMD.app CFBundleIdentifier: ${BID}"

if [[ "$BID" == "org.kindashub.clearly" ]] || [[ "$BID" == org.kindashub.* ]]; then
  echo ""
  echo "This app uses the OLD bundle ID. Delete it and reinstall:"
  echo "  rm -rf \"$APP\""
  echo "  ./scripts/install-clearlymd.sh"
  exit 1
fi

exit 0
