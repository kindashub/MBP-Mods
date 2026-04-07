# ClearlyMD — Setup guide (clean macOS install)

**ClearlyMD** shares **`~/TextMD`** + **`TX-…`** filenames with TextMD. **ClearlyEdit** is the Dock helper.

**This mod’s folder** keeps only the **`.app` bundles** at the top level. Everything you run from Terminal or read is under **`system/`**:

```
~/MBP-Mods/ClearlyMD/
├── ClearlyMD.app
├── ClearlyEdit.app
└── system/
    ├── ClearlyMD-SetupGuide.md   ← this file
    ├── clearlyedit-new-md.sh
    ├── clearlyedit               (created by setup-clearlymd.sh)
    ├── install-clearlymd.sh
    ├── setup-clearlymd.sh
    └── build-clearlyedit-app.sh
```

## What you get

- **ClearlyMD.app** — bundle **`com.clearlymd.editor`**.
- New notes: **`TX-<WDAY><YYYYMMDD>-<HHMMSS>.md`** in **`~/TextMD`**.
- **ClearlyEdit.app** — runs **`~/MBP-Mods/ClearlyMD/system/clearlyedit`**.
- Optional **`duti`** for `.md` → ClearlyMD.

---

## 1. Install ClearlyMD.app (editor)

[Releases](https://github.com/kindashub/MBP-Mods/releases): **`clearlymd-latest`**, asset **`Clearly-Debug-unsigned.zip`**.

```bash
cd ~/MBP-Mods/ClearlyMD/system
chmod +x install-clearlymd.sh
./install-clearlymd.sh
```

Installs **`~/MBP-Mods/ClearlyMD/ClearlyMD.app`** (parent of **`system/`**).

---

## 2. Full setup (recommended)

```bash
cd ~/MBP-Mods/ClearlyMD/system
chmod +x setup-clearlymd.sh install-clearlymd.sh
./setup-clearlymd.sh
```

Installs **`system/clearlyedit`**, editor (if Release exists), Launch Services, optional **`duti`**, builds **ClearlyEdit.app** next to **`system/`** (in **`ClearlyMD/`** root).

---

## 3. PATH (optional)

```bash
export PATH="$HOME/MBP-Mods/ClearlyMD/system:$PATH"
```

---

## 4. Register + default `.md` app

```bash
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
"$LSREGISTER" -f -R -trusted "$HOME/MBP-Mods/ClearlyMD/ClearlyMD.app"
```

```bash
brew install duti
duti -s com.clearlymd.editor net.daringfireball.markdown all
```

---

## 5. Rebuild ClearlyEdit.app

**ClearlyEdit.app** uses a tiny **Mach-O** binary (`clearlyedit-launcher.c` → **`clang`**) as **`CFBundleExecutable`**, which **`execl`** **`/bin/bash`** on **`system/clearlyedit`**. That avoids Dock issues with **script-only** bundle executables and restores a normal app **icon** (copied from **ClearlyMD.app**’s **`applet.icns`**, or TextEdit / generic fallback).

Requires **Xcode Command Line Tools** (`clang`). Install: **`xcode-select --install`**.

```bash
cd ~/MBP-Mods/ClearlyMD/system
./build-clearlyedit-app.sh
```

Output: **`~/MBP-Mods/ClearlyMD/ClearlyEdit.app`** (ad-hoc **`codesign`** + Launch Services registration).

---

## Environment variables

| Variable | Purpose |
|----------|---------|
| `TEXTEDIT_DEFAULT_DIR` | Notes folder (default **`~/TextMD`**). |
| `TEXTEDIT_PREFIX` | Prefix (default **`TX`**). |
| `CLEARLYMD_APP` | Override (default **`~/MBP-Mods/ClearlyMD/ClearlyMD.app`**). |
| `CLEARLYMD_RELEASE_REPO` | Default **`kindashub/MBP-Mods`**. |
| `CLEARLYMD_RELEASE_TAG` | Default **`clearlymd-latest`**. |

---

## Troubleshooting

### Error: `org.kindashub.clearly` or `LSCopyApplicationURLsForBundleIdentifier`

Your **ClearlyMD.app** is probably an **old build** (bundle ID was renamed to **`com.clearlymd.editor`**). macOS cannot open it correctly.

1. Check:
   ```bash
   ~/MBP-Mods/ClearlyMD/system/verify-clearlymd-app.sh
   ```
2. Remove the old app and reinstall from **[Releases](https://github.com/kindashub/MBP-Mods/releases)** (`clearlymd-latest` → **`Clearly-Debug-unsigned.zip`**) or run **`./install-clearlymd.sh`** here.
3. Run **`./setup-clearlymd.sh`** again (registers Launch Services + `duti`).

### ClearlyEdit does nothing when clicked

1. Rebuild **`ClearlyEdit.app`** (Mach-O launcher → **`clearlyedit`**):
   ```bash
   cd ~/MBP-Mods/ClearlyMD/system
   ./build-clearlyedit-app.sh
   ```
2. Ensure **`clearlyedit`** exists and is executable:
   ```bash
   cp clearlyedit-new-md.sh clearlyedit && chmod +x clearlyedit
   ```
3. **`killall Dock`** (or remove the Dock icon and drag **`~/MBP-Mods/ClearlyMD/ClearlyEdit.app`** back) so the Dock does not keep a stale handle to an old build.

### ClearlyEdit shows a blank white icon

Rebuild with **`./build-clearlyedit-app.sh`** — it copies **`applet.icns`** from **`ClearlyMD.app`** when present. Install **ClearlyMD.app** first, or the script falls back to TextEdit / generic icons.

---

*Bundle IDs: **`com.clearlymd.editor`**, **`com.clearlymd.editor.quicklook`**.*
