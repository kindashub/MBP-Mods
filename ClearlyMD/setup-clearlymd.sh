#!/usr/bin/env bash
# ClearlyMD: launcher, editor from Releases, ClearlyEdit Dock app, optional duti.
# Everything for this mod lives under ~/MBP-Mods/ClearlyMD/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAUNCHER_SRC="${SCRIPT_DIR}/clearlyedit-new-md.sh"
INSTALL_APP="${SCRIPT_DIR}/install-clearlymd.sh"
MBP_MODS="${HOME}/MBP-Mods"
MOD_DIR="${MBP_MODS}/ClearlyMD"
BIN_LAUNCHER="${MOD_DIR}/clearlyedit"
DEFAULT_DIR="${TEXTEDIT_DEFAULT_DIR:-$HOME/TextMD}"

if [[ ! -f "$LAUNCHER_SRC" ]]; then
  echo "error: missing ${LAUNCHER_SRC}" >&2
  exit 1
fi

echo "==> ClearlyMD mod directory: ${MOD_DIR}"
mkdir -p "$MOD_DIR" "$DEFAULT_DIR"

# Migrate legacy flat layout (older docs used ~/MBP-Mods/ClearlyMD.app at top level)
if [[ -d "${MBP_MODS}/ClearlyMD.app" && ! -d "${MOD_DIR}/ClearlyMD.app" ]]; then
  echo "==> Moving legacy ${MBP_MODS}/ClearlyMD.app → ${MOD_DIR}/"
  mv "${MBP_MODS}/ClearlyMD.app" "${MOD_DIR}/"
fi
if [[ -d "${MBP_MODS}/ClearlyEdit.app" && ! -d "${MOD_DIR}/ClearlyEdit.app" ]]; then
  echo "==> Moving legacy ${MBP_MODS}/ClearlyEdit.app → ${MOD_DIR}/"
  mv "${MBP_MODS}/ClearlyEdit.app" "${MOD_DIR}/"
fi
rm -f "${MBP_MODS}/bin/clearlyedit" 2>/dev/null || true

echo "==> Install launcher: ${BIN_LAUNCHER}"
cp "$LAUNCHER_SRC" "$BIN_LAUNCHER"
chmod +x "$BIN_LAUNCHER"

if [[ -f "$INSTALL_APP" ]]; then
  echo "==> ClearlyMD.app ← GitHub Release"
  set +e
  bash "$INSTALL_APP"
  fork_rc=$?
  set -e
  if [[ $fork_rc -ne 0 ]]; then
    echo "    (ClearlyMD.app not installed — check Release clearlymd-latest on kindashub/MBP-Mods.)"
  fi
else
  echo "==> (install-clearlymd.sh not found; skipped)"
fi

rm -rf "${HOME}/Applications/ClearlyMD.app" "${HOME}/Applications/Clearly-KindasOS.app" 2>/dev/null || true

FORK_BUNDLE="${CLEARLYMD_BUNDLE_ID:-com.clearlymd.editor}"
FORK_APP="${MOD_DIR}/ClearlyMD.app"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

if [[ -x "$LSREGISTER" ]]; then
  echo "==> Drop stale Markdown app registrations"
  shopt -s nullglob
  for stale in \
    "/Applications/MacDown.app" \
    "${HOME}/Applications/MacDown.app" \
    "${HOME}/.Trash"/MacDown*.app; do
    if [[ -d "$stale" ]]; then
      "$LSREGISTER" -u -r "$stale" 2>/dev/null || true
    fi
  done
  shopt -u nullglob
fi

if [[ -d "$FORK_APP" && -x "$LSREGISTER" ]]; then
  echo "==> Register ClearlyMD with Launch Services"
  "$LSREGISTER" -f -R -trusted "$FORK_APP" 2>/dev/null || true
fi

if [[ -d "$FORK_APP" ]]; then
  echo "==> Clear Icon Services cache (may prompt for password)"
  if sudo -n rm -rf /Library/Caches/com.apple.iconservices.store 2>/dev/null; then
    true
  elif command -v osascript >/dev/null 2>&1; then
    osascript -e 'do shell script "rm -rf /Library/Caches/com.apple.iconservices.store" with administrator privileges' 2>/dev/null || true
  elif command -v sudo >/dev/null 2>&1; then
    sudo rm -rf /Library/Caches/com.apple.iconservices.store 2>/dev/null || true
  fi
  if command -v duti >/dev/null 2>&1; then
    echo "==> Default app for Markdown → ClearlyMD (${FORK_BUNDLE})"
    duti -s "$FORK_BUNDLE" net.daringfireball.markdown all
    duti -s "$FORK_BUNDLE" public.markdown all 2>/dev/null || true
    rm -rf "${HOME}/Library/Caches/com.apple.iconservices.store" 2>/dev/null || true
    qlmanage -r cache >/dev/null 2>&1 || true
    killall IconServicesAgent 2>/dev/null || true
    killall Finder 2>/dev/null || true
  else
    echo ""
    echo "Install duti for system-wide .md default: brew install duti"
    echo "Then re-run this script."
  fi
else
  echo "==> (Skip .md default: install ClearlyMD to ${FORK_APP} first.)"
fi

DOCK_APP="${MOD_DIR}/ClearlyEdit.app"
if [[ "$(uname -s)" == Darwin ]] && command -v osacompile >/dev/null 2>&1; then
  echo "==> Dock helper (ClearlyEdit): ${DOCK_APP}"
  TMP="$(mktemp -t clearlyedit)"
  cat > "$TMP" <<APPLESCRIPT
on run
	set h to POSIX path of (path to home folder)
	do shell script quoted form of (h & "MBP-Mods/ClearlyMD/clearlyedit")
end run
APPLESCRIPT
  osacompile -o "$DOCK_APP" "$TMP"
  rm -f "$TMP"
fi

echo ""
echo "-------------------------------------------------------------------"
echo "Editor:    ${FORK_APP}"
echo "New note:  ${BIN_LAUNCHER}"
echo "Dock:      ${DOCK_APP}"
echo "-------------------------------------------------------------------"
