#!/usr/bin/env bash
# ClearlyMD: install ClearlyEdit launcher, ClearlyMD editor from GitHub Releases, Dock helper, optional duti for .md.
# Does not change TextEdit or the TextMD mod.
#
# Outputs live under ~/MBP-Mods/ (not ~/Applications).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAUNCHER_SRC="${SCRIPT_DIR}/clearlyedit-new-md.sh"
INSTALL_APP="${SCRIPT_DIR}/install-clearlymd.sh"
MBP_MODS="${HOME}/MBP-Mods"
BIN_DIR="${MBP_MODS}/bin"
BIN_LAUNCHER="${BIN_DIR}/clearlyedit"
DEFAULT_DIR="${TEXTEDIT_DEFAULT_DIR:-$HOME/TextMD}"

if [[ ! -f "$LAUNCHER_SRC" ]]; then
  echo "error: missing ${LAUNCHER_SRC}" >&2
  exit 1
fi

echo "==> ClearlyMD home: ${MBP_MODS}"
mkdir -p "$MBP_MODS" "$DEFAULT_DIR"

echo "==> Install ClearlyEdit launcher: ${BIN_LAUNCHER}"
mkdir -p "$BIN_DIR"
cp "$LAUNCHER_SRC" "$BIN_LAUNCHER"
chmod +x "$BIN_LAUNCHER"

if [[ -f "$INSTALL_APP" ]]; then
  echo "==> ClearlyMD.app ← GitHub Release (this repo)"
  set +e
  bash "$INSTALL_APP"
  fork_rc=$?
  set -e
  if [[ $fork_rc -ne 0 ]]; then
    echo "    (ClearlyMD.app not installed — add Release ${CLEARLYMD_RELEASE_TAG:-clearlymd-latest} with ${CLEARLYMD_RELEASE_REPO:-kindashub/MBP-Mods} or check network.)"
  fi
else
  echo "==> (install-clearlymd.sh not found; skipped)"
fi

rm -rf "${HOME}/Applications/ClearlyMD.app" 2>/dev/null || true

if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "Tip: add ${BIN_DIR} to PATH (e.g. in ~/.zprofile) or run ${BIN_LAUNCHER} by full path."
fi

FORK_BUNDLE="${CLEARLYMD_BUNDLE_ID:-com.clearlymd.editor}"
FORK_APP="${MBP_MODS}/ClearlyMD.app"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

if [[ -x "$LSREGISTER" ]]; then
  echo "==> Drop stale Markdown app registrations (Finder .md icons)"
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
  echo "==> Clear system Icon Services cache (may prompt for password)"
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

DOCK_APP="${MBP_MODS}/ClearlyEdit.app"
if [[ "$(uname -s)" == Darwin ]] && command -v osacompile >/dev/null 2>&1; then
  echo "==> Dock helper (ClearlyEdit): ${DOCK_APP}"
  TMP="$(mktemp -t clearlyedit)"
  cat > "$TMP" <<APPLESCRIPT
on run
	set h to POSIX path of (path to home folder)
	do shell script quoted form of (h & "MBP-Mods/bin/clearlyedit")
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
