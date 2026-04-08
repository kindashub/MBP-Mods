# ClearlyMD (fork in `external/clearly/`)

Upstream: [Shpigford/clearly](https://github.com/Shpigford/clearly). This tree adds **Inconsolata**, **Blueprint** strip, **column ruler**, **⌘⌥B**.

## Distribution (single source of truth)

**Unsigned app zip:** GitHub **kindashub/KindasOS** → Releases → tag **`clearlymd-latest`** → **`Clearly-Debug-unsigned.zip`**.

CI: `.github/workflows/clearly-external.yml` runs `xcodegen` + `xcodebuild` on `macos-15` and attaches that zip to the release.

**Install to `~/MBP-Mods/ClearlyMD/ClearlyMD.app`:**

```bash
./scripts/install-clearlymd.sh
```

Default download is **kindashub/KindasOS** (not MBP-Mods). Override: `CLEARLYMD_RELEASE_REPO`.

**Full macOS integration** (launcher, `duti` for `.md`, Dock **ClearlyEdit**, Launch Services):

```bash
./scripts/setup-clearlymd.sh
```

**Optional:** `./scripts/install-clearlymd.sh --system` → `/Applications/ClearlyMD.app` (sudo).

**Local build:** `cd external/clearly && brew install xcodegen && xcodegen generate && open Clearly.xcodeproj` → ⌘B (requires full **Xcode**, not only Command Line Tools).

## MBP-Mods mirror

[kindashub/MBP-Mods](https://github.com/kindashub/MBP-Mods) holds **`ClearlyMD/system/`** scripts (same behavior as KindasOS `scripts/` + `setup-clearlymd.sh` paths). The **editor binary** always comes from the **KindasOS** release zip above unless you build locally.
