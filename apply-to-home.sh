#!/usr/bin/env bash
# Copy only the mod folders into ~/MBP-Mods/ (no README/CHANGELOG at home).
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
rsync -a --delete "${ROOT}/ClearlyMD/" "${DEST}/ClearlyMD/"

echo "==> Done. Guides: ${DEST}/TextMD/TextMD-SetupGuide.md"
echo "            ${DEST}/ClearlyMD/ClearlyMD-SetupGuide.md"
echo "    (Repo README/CHANGELOG were not copied.)"
