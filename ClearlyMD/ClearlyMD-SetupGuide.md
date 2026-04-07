# ClearlyMD — Setup guide (clean macOS install)

**ClearlyMD** (Inconsolata, Blueprint strip, column ruler) shares the same **`~/TextMD`** naming as **TextMD**. **ClearlyEdit** is the Dock helper (like **TextMD.app**).

**On your Mac**, keep this layout (matches the **ClearlyMD/** folder in the repo):

```
~/MBP-Mods/ClearlyMD/
├── ClearlyMD.app           ← editor (from Release or manual ditto)
├── ClearlyEdit.app         ← Dock helper (build with build-clearlyedit-app.sh)
├── clearlyedit             ← copy from clearlyedit-new-md.sh (setup script does this)
├── clearlyedit-new-md.sh
├── install-clearlymd.sh
├── setup-clearlymd.sh
├── build-clearlyedit-app.sh
└── ClearlyMD-SetupGuide.md
```

## What you get

- **ClearlyMD.app** — bundle ID **`com.clearlymd.editor`** (not App Store Clearly).
- New notes: **`TX-<WDAY><YYYYMMDD>-<HHMMSS>.md`** under **`~/TextMD`**.
- **ClearlyEdit.app** — runs **`~/MBP-Mods/ClearlyMD/clearlyedit`**.
- Optional: **`duti`** so `.md` opens in ClearlyMD.

| Item | Role |
|------|------|
| `clearlyedit-new-md.sh` | Installed as **`~/MBP-Mods/ClearlyMD/clearlyedit`** by **`setup-clearlymd.sh`**. |
| `ClearlyEdit.app` | Stays in **`~/MBP-Mods/ClearlyMD/`** — add to Dock. |
| `install-clearlymd.sh` | Downloads **ClearlyMD.app** into **`~/MBP-Mods/ClearlyMD/`**. |

---

## 1. Install ClearlyMD.app (editor)

[Releases](https://github.com/kindashub/MBP-Mods/releases): tag **`clearlymd-latest`**, asset **`Clearly-Debug-unsigned.zip`** → contains **`Clearly.app`** → install as **`ClearlyMD.app`** next to the other files in **`~/MBP-Mods/ClearlyMD/`**.

```bash
cd /path/to/MBP-Mods/ClearlyMD
chmod +x install-clearlymd.sh
./install-clearlymd.sh
```

**Manual:**

```bash
mkdir -p "$HOME/MBP-Mods/ClearlyMD"
ditto Clearly.app "$HOME/MBP-Mods/ClearlyMD/ClearlyMD.app"
xattr -dr com.apple.quarantine "$HOME/MBP-Mods/ClearlyMD/ClearlyMD.app" 2>/dev/null || true
```

---

## 2. One-shot setup (recommended)

From **`ClearlyMD/`** (repo path or **`~/MBP-Mods/ClearlyMD/`** after `apply-to-home.sh`):

```bash
chmod +x setup-clearlymd.sh install-clearlymd.sh
./setup-clearlymd.sh
```

Installs **`clearlyedit`**, downloads the editor if the Release exists, Launch Services, optional **`duti`**, builds **ClearlyEdit.app** inside **`~/MBP-Mods/ClearlyMD/`**.

---

## 3. PATH (optional)

To run **`clearlyedit`** by name:

```bash
export PATH="$HOME/MBP-Mods/ClearlyMD:$PATH"
```

Or always use the full path **`~/MBP-Mods/ClearlyMD/clearlyedit`**.

---

## 4. Register ClearlyMD + default `.md` app

```bash
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
"$LSREGISTER" -f -R -trusted "$HOME/MBP-Mods/ClearlyMD/ClearlyMD.app"
```

```bash
brew install duti
duti -s com.clearlymd.editor net.daringfireball.markdown all
duti -s com.clearlymd.editor public.markdown all 2>/dev/null || true
```

---

## 5. ClearlyEdit.app (Dock)

```bash
cd ~/MBP-Mods/ClearlyMD
./build-clearlyedit-app.sh
```

**ClearlyEdit.app** is created **in this folder**. Drag it to the Dock.

---

## 6. Coexistence with TextMD

Same **`~/TextMD`** folder and **`TX-…`** names; only one app should be the system default for `.md`.

---

## Environment variables

| Variable | Purpose |
|----------|---------|
| `TEXTEDIT_DEFAULT_DIR` | Notes folder (default **`~/TextMD`**). |
| `TEXTEDIT_PREFIX` | Filename prefix (default **`TX`**). |
| `CLEARLYMD_APP` | Override path to **ClearlyMD.app** (default **`~/MBP-Mods/ClearlyMD/ClearlyMD.app`**). |
| `CLEARLYMD_RELEASE_REPO` | GitHub repo for zip (default **`kindashub/MBP-Mods`**). |
| `CLEARLYMD_RELEASE_TAG` | Release tag (default **`clearlymd-latest`**). |

---

*Bundle IDs: **`com.clearlymd.editor`**, Quick Look **`com.clearlymd.editor.quicklook`**.*
