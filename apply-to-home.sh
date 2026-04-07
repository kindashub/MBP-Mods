#!/usr/bin/env bash
# Copy TextMD/ and ClearlyMD/ into ~/MBP-Mods/ (no repo root files).
# Run from the root of a clone of github.com/kindashub/MBP-Mods.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/MBP-Mods"

for d in TextMD ClearlyMD; do
  if [[ ! -d "${ROOT}/${d}" ]]; then
    echo "error: missing ${ROOT}/${d}" >&2
    exit 1
  fi
done

mkdir -p "${DEST}"
echo "==> Syncing TextMD/ and ClearlyMD/ → ${DEST}/"
rsync -a --delete "${ROOT}/TextMD/" "${DEST}/TextMD/"
# Exclude GitHub-only index inside ClearlyMD/system/
rsync -a --delete --exclude='system/README.md' "${ROOT}/ClearlyMD/" "${DEST}/ClearlyMD/"

echo "==> Done."
echo "    TextMD:  ${DEST}/TextMD/system/TextMD-SetupGuide.md"
echo "    ClearlyMD: ${DEST}/ClearlyMD/system/ClearlyMD-SetupGuide.md"
