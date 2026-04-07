#!/usr/bin/env bash
# ClearlyMD: launcher, editor from Releases, ClearlyEdit Dock app, optional duti.
# Run from: ~/MBP-Mods/ClearlyMD/system/setup-clearlymd.sh
# Root of mod folder only contains *.app — scripts live in system/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOD_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LAUNCHER_SRC="${SCRIPT_DIR}/clearlyedit-new-md.sh"
INSTALL_APP="${SCRIPT_DIR}/install-clearlymd.sh"
MBP_MODS="${HOME}/MBP-Mods"
BIN_LAUNCHER="${SCRIPT_DIR}/clearlyedit"
DEFAULT_DIR="${TEXTEDIT_DEFAULT_DIR:-$HOME/TextMD}"

if [[ ! -f "$LAUNCHER_SRC" ]]; then
  echo "error: missing ${LAUNCHER_SRC}" >&2
  exit 1
fi

echo "==> ClearlyMD mod: ${MOD_DIR} (apps here, scripts in system/)"
mkdir -p "${SCRIPT_DIR}" "$MOD_DIR" "$DEFAULT_DIR"

# Migrate pre-system layout
if [[ -f "${MOD_DIR}/clearlyedit" && ! -f "${BIN_LAUNCHER}" ]]; then
  mv "${MOD_DIR}/clearlyedit" "${BIN_LAUNCHER}"
  echo "==> Moved clearlyedit → system/"
fi

rm -f "${MBP_MODS}/bin/clearlyedit" 2>/dev/null || true

if [[ -d "${MBP_MODS}/ClearlyMD.app" && ! -d "${MOD_DIR}/ClearlyMD.app" ]]; then
  mv "${MBP_MODS}/ClearlyMD.app" "${MOD_DIR}/"
fi
if [[ -d "${MBP_MODS}/ClearlyEdit.app" && ! -d "${MOD_DIR}/ClearlyEdit.app" ]]; then
  mv "${MBP_MODS}/ClearlyEdit.app" "${MOD_DIR}/"
fi

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
BUILD_EDIT="${SCRIPT_DIR}/build-clearlyedit-app.sh"
if [[ "$(uname -s)" == Darwin && -x "$BUILD_EDIT" ]]; then
  echo "==> Dock helper (ClearlyEdit): ${DOCK_APP}"
  bash "$BUILD_EDIT"
fi

echo ""
echo "-------------------------------------------------------------------"
echo "Editor:    ${FORK_APP}"
echo "New note:  ${BIN_LAUNCHER}"
echo "Dock:      ${DOCK_APP}"
echo "-------------------------------------------------------------------"
