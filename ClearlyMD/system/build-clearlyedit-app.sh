#!/usr/bin/env bash
# Build ClearlyEdit.app next to this mod folder (sibling of system/). Applet runs system/clearlyedit.

set -euo pipefail

if [[ "$(uname -s)" != Darwin ]] || ! command -v osacompile >/dev/null 2>&1; then
  echo "error: osacompile not found (run on macOS)" >&2
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${HERE}/.." && pwd)"
OUT="${ROOT}/ClearlyEdit.app"
TMP="$(mktemp -t clearlyedit)"
cleanup() { rm -f "$TMP"; }
trap cleanup EXIT

cat > "$TMP" <<'APPLESCRIPT'
on run
	set h to POSIX path of (path to home folder)
	do shell script quoted form of (h & "MBP-Mods/ClearlyMD/system/clearlyedit")
end run
APPLESCRIPT

rm -rf "$OUT"
osacompile -o "$OUT" "$TMP"
echo "==> Built ${OUT}"
