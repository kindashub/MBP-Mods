# ClearlyMD (macOS)

## What this is

- **`ClearlyMD.app`** — Swift editor (Blueprint, ruler, Inconsolata). **Not** a Script Editor applet. Main binary must be named **`Clearly`**.
- **`ClearlyEdit.app`** — Dock helper: creates a new `.md` in `~/TextMD` and opens it in ClearlyMD. Built by **`system/build-clearlyedit-app.sh`** (requires Xcode Command Line Tools for `clang`).
- **`system/clearlyedit`** — Shell script (from `clearlyedit-new-md.sh`).

## Editor binary (single source)

The unsigned zip **`Clearly-Debug-unsigned.zip`** is published by **CI on [kindashub/KindasOS](https://github.com/kindashub/KindasOS)** — Release tag **`clearlymd-latest`**.

Install:

```bash
~/MBP-Mods/ClearlyMD/system/install-clearlymd.sh
```

Default download repo is **kindashub/KindasOS** (override: `CLEARLYMD_RELEASE_REPO`).

Full integration (default app for `.md`, Launch Services, ClearlyEdit):

```bash
~/MBP-Mods/ClearlyMD/system/setup-clearlymd.sh
```

Requires **`duti`** (`brew install duti`) for system-wide default.

## Verify

```bash
~/MBP-Mods/ClearlyMD/system/verify-clearlymd-app.sh
```

Fails if **`ClearlyMD.app`** is wrong (e.g. `CFBundleExecutable` = `applet`).

## If `.md` icons are white or wrong app opens

1. Reinstall editor: `install-clearlymd.sh`
2. Re-run: `setup-clearlymd.sh` (registers app + `duti` + icon caches)
