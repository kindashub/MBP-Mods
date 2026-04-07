#!/bin/bash
# Sanity-check ClearlyMD.app: Swift editor (Clearly), not a Script Editor applet.

set -euo pipefail

APP="${HOME}/MBP-Mods/ClearlyMD/ClearlyMD.app"
if [[ ! -d "$APP" ]]; then
  echo "error: missing ${APP}" >&2
  echo "Run: ./scripts/install-clearlymd.sh" >&2
  exit 1
fi

EXE="$(defaults read "$APP/Contents/Info" CFBundleExecutable 2>/dev/null || echo "")"
BID="$(defaults read "$APP/Contents/Info" CFBundleIdentifier 2>/dev/null || echo "")"

if [[ -z "$BID" ]]; then
  echo "error: could not read CFBundleIdentifier" >&2
  exit 2
fi

echo "ClearlyMD.app CFBundleExecutable: ${EXE:-?}"
echo "ClearlyMD.app CFBundleIdentifier: ${BID}"

if [[ "$EXE" == "applet" ]] || [[ -z "$EXE" ]]; then
  echo ""
  echo "Wrong bundle: this folder is a Script Editor applet or incomplete, not ClearlyMD."
  echo "  rm -rf \"$APP\" && ./scripts/install-clearlymd.sh"
  exit 1
fi

if [[ "$EXE" != "Clearly" ]]; then
  echo ""
  echo "error: expected main executable 'Clearly', got '${EXE}'" >&2
  exit 1
fi

if [[ "$BID" == org.kindashub.* ]]; then
  echo ""
  echo "note: legacy bundle ID (org.kindashub.*). Run ./scripts/install-clearlymd.sh after the next ClearlyMD CI build for com.clearlymd.editor."
fi

exit 0
