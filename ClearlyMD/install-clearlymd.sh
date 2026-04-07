#!/usr/bin/env bash
# Download ClearlyMD.app from this repo’s GitHub Releases and install as ~/MBP-Mods/ClearlyMD.app.
#
# Default: ~/MBP-Mods/ClearlyMD.app (no sudo). Optional: --system → /Applications/ClearlyMD.app (sudo).
#
# Releases: tag clearlymd-latest, asset Clearly-Debug-unsigned.zip (contains Clearly.app).
# Override: CLEARLYMD_RELEASE_REPO / CLEARLYMD_RELEASE_TAG.

set -euo pipefail

REPO="${CLEARLYMD_RELEASE_REPO:-kindashub/MBP-Mods}"
TAG="${CLEARLYMD_RELEASE_TAG:-clearlymd-latest}"
ZIP_NAME="Clearly-Debug-unsigned.zip"
URL="https://github.com/${REPO}/releases/download/${TAG}/${ZIP_NAME}"

INSTALL_SYSTEM=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --system) INSTALL_SYSTEM=true; shift ;;
    -h|--help)
      echo "Usage: $0 [--system]"
      echo "  (default) Install to ~/MBP-Mods/ClearlyMD.app"
      echo "  --system  Install to /Applications/ClearlyMD.app (requires sudo)"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "==> Downloading ${ZIP_NAME} from ${REPO}@${TAG}"
if command -v gh >/dev/null 2>&1 && gh auth status &>/dev/null; then
  gh release download "$TAG" -R "$REPO" -p "$ZIP_NAME" -D "$TMP" --clobber 2>/dev/null || true
fi
if [[ ! -f "$TMP/$ZIP_NAME" ]]; then
  if ! curl -fsSL -o "$TMP/$ZIP_NAME" "$URL"; then
    echo "error: could not download ${ZIP_NAME} from ${URL}" >&2
    echo "hint: ensure a Release ${TAG} exists with that asset, or: gh auth login" >&2
    exit 1
  fi
fi

echo "==> Unzipping"
unzip -q "$TMP/$ZIP_NAME" -d "$TMP"

test -d "$TMP/Clearly.app" || {
  echo "error: archive did not contain Clearly.app" >&2
  exit 1
}

if [[ "$INSTALL_SYSTEM" == true ]]; then
  echo "==> Installing to /Applications/ClearlyMD.app (sudo)"
  sudo ditto "$TMP/Clearly.app" /Applications/ClearlyMD.app
else
  TARGET_ROOT="${HOME}/MBP-Mods"
  mkdir -p "$TARGET_ROOT"
  TARGET="${TARGET_ROOT}/ClearlyMD.app"
  echo "==> Installing to ${TARGET}"
  rm -rf "$TARGET"
  ditto "$TMP/Clearly.app" "$TARGET"
  xattr -dr com.apple.quarantine "$TARGET" 2>/dev/null || true
fi

echo "==> Done."
