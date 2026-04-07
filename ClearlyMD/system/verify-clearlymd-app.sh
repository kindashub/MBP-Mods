#!/bin/bash
# Print ClearlyMD.app bundle ID and warn if it is an old KindasOS-era build.

set -euo pipefail

APP="${HOME}/MBP-Mods/ClearlyMD/ClearlyMD.app"
if [[ ! -d "$APP" ]]; then
  echo "error: missing ${APP}" >&2
  echo "Run: ./install-clearlymd.sh (same folder)" >&2
  exit 1
fi

BID="$(defaults read "$APP/Contents/Info" CFBundleIdentifier 2>/dev/null || echo "(read failed)")"
echo "ClearlyMD.app CFBundleIdentifier: ${BID}"

if [[ "$BID" == "org.kindashub.clearly" ]] || [[ "$BID" == org.kindashub.* ]]; then
  echo ""
  echo "This build uses the OLD bundle ID. macOS will show Launch Services errors and Dock may break."
  echo "Fix: delete this app, then reinstall from Release (zip built with com.clearlymd.editor):"
  echo "  rm -rf \"$APP\""
  echo "  ./install-clearlymd.sh"
  echo "Or from a KindasOS checkout: ./scripts/install-clearlymd.sh"
  exit 1
fi

if [[ "$BID" != "com.clearlymd.editor" ]]; then
  echo "warning: expected com.clearlymd.editor — if the app misbehaves, reinstall from clearlymd-latest." >&2
fi

exit 0
