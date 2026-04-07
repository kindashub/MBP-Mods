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

```bash
cd ~/MBP-Mods/ClearlyMD/system
./build-clearlyedit-app.sh
```

Output: **`~/MBP-Mods/ClearlyMD/ClearlyEdit.app`**.

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

*Bundle IDs: **`com.clearlymd.editor`**, **`com.clearlymd.editor.quicklook`**.*
