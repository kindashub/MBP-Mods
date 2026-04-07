#!/usr/bin/env bash
# Build ClearlyEdit.app next to this mod folder (sibling of system/). Uses a bash
# executable as CFBundleExecutable — more reliable than AppleScript Dock applets.

set -euo pipefail

if [[ "$(uname -s)" != Darwin ]]; then
  echo "error: run on macOS" >&2
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOD_DIR="$(cd "${HERE}/.." && pwd)"
SYS_DIR="${HERE}"
DOCK_APP="${MOD_DIR}/ClearlyEdit.app"
BIN_LAUNCHER="${SYS_DIR}/clearlyedit"

if [[ ! -x "$BIN_LAUNCHER" ]]; then
  echo "error: missing executable ${BIN_LAUNCHER}" >&2
  echo "Run setup-clearlymd.sh first (installs launcher from clearlyedit-new-md.sh)." >&2
  exit 1
fi

echo "==> Building ${DOCK_APP}"
rm -rf "$DOCK_APP"
mkdir -p "${DOCK_APP}/Contents/MacOS"

cat > "${DOCK_APP}/Contents/MacOS/ClearlyEdit" <<'STUB'
#!/bin/bash
# ClearlyEdit.app entry — Dock/Finder; avoid AppleScript "do shell script" edge cases.
set -euo pipefail
if [[ -z "${HOME:-}" ]]; then
  HOME="$(/usr/bin/dscl . -read "/Users/$(/usr/bin/id -un)" NFSHomeDirectory 2>/dev/null | /usr/bin/awk '{print $2}')"
  export HOME
fi
exec "${HOME}/MBP-Mods/ClearlyMD/system/clearlyedit"
STUB
chmod +x "${DOCK_APP}/Contents/MacOS/ClearlyEdit"

cat > "${DOCK_APP}/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>ClearlyEdit</string>
	<key>CFBundleIdentifier</key>
	<string>com.clearlymd.clearlyedit</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>ClearlyEdit</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.1</string>
	<key>CFBundleVersion</key>
	<string>2</string>
	<key>LSMinimumSystemVersion</key>
	<string>11.0</string>
	<key>NSHighResolutionCapable</key>
	<true/>
</dict>
</plist>
PLIST

if command -v codesign >/dev/null 2>&1; then
  codesign --force --deep -s - "$DOCK_APP" 2>/dev/null || true
fi

LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
if [[ -x "$LSREGISTER" ]]; then
  "$LSREGISTER" -f -R -trusted "$DOCK_APP" 2>/dev/null || true
fi

echo "==> ClearlyEdit.app ready (bash stub, not AppleScript)."
