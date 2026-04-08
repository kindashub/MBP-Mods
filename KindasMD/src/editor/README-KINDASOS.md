# Clearly (KindasOS fork snapshot)

## If this felt confusing

The **features** (Inconsolata, Blueprint, ruler) live in this Swift tree. Turning them into a **`.app`** needs **Xcode** locally **or** **CI** (GitHub Actions builds on push).

**Install the built app (after CI has published the Release on `main`):** from the KindasOS repo root:

```bash
./scripts/install-clearly-kindasos-from-release.sh
```

That downloads **`Clearly-Debug-unsigned.zip`** from Release **`clearly-kindasos-latest`** and installs **`Clearly.app`** as **`~/Applications/Clearly-KindasOS.app`** by default (no sudo). Private repo: **`gh auth login`** first so **`gh release download`** works; the script falls back to **`curl`** when possible.

**`~/bin/clearly-new-md`** and **`~/Applications/ClearlyMD.app`** (from `setup-clearly-md-default.sh`) call **`open -a ~/Applications/Clearly-KindasOS.app`** when that folder exists. The fork uses bundle ID **`org.kindashub.clearly`** (not App Store **`com.sabotage.clearly`**), so **`duti`** and Finder can target this app for `.md` without opening the wrong build. If the fork app is missing, they fall back to **`open -b org.kindashub.clearly`** (after you have installed the fork once, Launch Services knows that ID).

**Optional:** `./scripts/install-clearly-kindasos-from-release.sh --system` installs to **`/Applications/Clearly.app`** (sudo), replacing the App Store build for **all** launches (including double-click `.md`).

**Manual:** Download the zip from the repo’s **Releases** page, unzip, drag **`Clearly.app`** where you want.

**Local build:** `cd external/clearly && xcodegen generate && open Clearly.xcodeproj` then **⌘B**.

---

This tree is based on [Shpigford/clearly](https://github.com/Shpigford/clearly) with local changes:

- **Inconsolata** — Bundled `Clearly/Resources/fonts/Inconsolata-Regular.ttf` (SIL OFL; see `OFL-Inconsolata.txt` in the same folder), registered at launch; `Theme.editorFont` prefers Inconsolata with system monospaced fallback.
- **Blueprint** — Global scratch strip (`UserDefaults` keys `blueprintText`, `blueprintVisible`), not stored in `.md` files. Toolbar button (grid icon) or **⌘⌥B** toggles visibility; hidden by default.
- **Column ruler** — Monospace column ticks above the editor, aligned with `Theme.editorInsetX` and character advance.

Branch name used during development: `feature/inconsolata-blueprint-ruler`.

## Build

### Option A — No local Xcode (CI)

Pushes that touch `external/clearly/**` run **GitHub Actions** (`.github/workflows/clearly-external.yml`): `xcodegen` + `xcodebuild` on a macOS runner. Open the **Actions** tab to see compile status.

### Option B — Local machine

Requires **Xcode.app** (not only Command Line Tools) for a normal GUI build. From this directory:

```bash
xcodegen generate   # produces Clearly.xcodeproj (ignored upstream; install: brew install xcodegen)
open Clearly.xcodeproj
```

Then **Product → Build** the **Clearly** scheme, or:

```bash
xcodebuild -scheme Clearly -configuration Debug build
```

Upstream ignores `*.xcodeproj`; regenerate with `xcodegen` after cloning.

**Why not plain `swift build`?** Clearly is an Xcode project (SwiftUI, Sparkle, Quick Look extension, bundled resources). A full Swift Package migration would be a separate effort; the supported path is `xcodegen` + `xcodebuild` or CI above.

## License

Clearly remains MIT (upstream). Inconsolata is [SIL Open Font License](https://fonts.google.com/specimen/Inconsolata).
