# ClearlyMD — Setup guide (clean macOS install)

Use **ClearlyMD** (Inconsolata, Blueprint strip, column ruler) with the same **`~/TextMD`** naming as **TextMD** (`TX-MON20260406-094222.md` style). **ClearlyEdit** is a small Dock helper — same role as **TextMD.app** + `textedit-new-md`.

**This bundle:** **`MBP-Mods/ClearlyMD/`** in [github.com/kindashub/MBP-Mods](https://github.com/kindashub/MBP-Mods). Clone the repo or copy this folder onto your Mac.

## What you get

- **ClearlyMD.app** — Markdown editor (bundle ID **`com.clearlymd.editor`**, not the App Store Clearly).
- New notes as **`TX-<WDAY><YYYYMMDD>-<HHMMSS>.md`** under **`~/TextMD`**.
- **ClearlyEdit.app** — Dock: new file → opens in ClearlyMD (runs **`~/MBP-Mods/bin/clearlyedit`**).
- Optional: system default for `.md` → ClearlyMD (`duti`).

| Item | Role |
|------|------|
| `clearlyedit-new-md.sh` | Copy to **`~/MBP-Mods/bin/clearlyedit`**, `chmod +x`. |
| `ClearlyEdit.app` | Copy to **`~/MBP-Mods/`**, add to Dock (or run **`build-clearlyedit-app.sh`**). |
| `install-clearlymd.sh` | Fetches **ClearlyMD.app** from **this repo’s GitHub Releases**. |
| *(Releases)* **ClearlyMD.app** | Zip **`Clearly-Debug-unsigned.zip`** (contains **`Clearly.app`**) — see §2. |

---

## 1. Layout on disk

| Path | Role |
|------|------|
| `~/MBP-Mods/ClearlyMD.app` | Editor. |
| `~/MBP-Mods/ClearlyEdit.app` | Dock helper. |
| `~/MBP-Mods/bin/clearlyedit` | Launcher (from `clearlyedit-new-md.sh`). |
| `~/TextMD/` | Notes folder (shared with TextMD if you use both). |

```bash
mkdir -p "$HOME/MBP-Mods/bin" "$HOME/TextMD"
cp "/path/to/ClearlyMD/clearlyedit-new-md.sh" "$HOME/MBP-Mods/bin/clearlyedit"
chmod +x "$HOME/MBP-Mods/bin/clearlyedit"
```

---

## 2. Install ClearlyMD.app (editor)

Releases live on **this** repo: [MBP-Mods Releases](https://github.com/kindashub/MBP-Mods/releases). Tag **`clearlymd-latest`**, asset **`Clearly-Debug-unsigned.zip`** (unzip contains **`Clearly.app`** → install as **`ClearlyMD.app`**).

**From a clone of MBP-Mods:**

```bash
cd /path/to/MBP-Mods/ClearlyMD
chmod +x install-clearlymd.sh
./install-clearlymd.sh
```

**Manual:** Download the zip from Releases, unzip, then:

```bash
mkdir -p "$HOME/MBP-Mods"
ditto Clearly.app "$HOME/MBP-Mods/ClearlyMD.app"
xattr -dr com.apple.quarantine "$HOME/MBP-Mods/ClearlyMD.app" 2>/dev/null || true
```

Private repo: `gh auth login`, then `gh release download clearlymd-latest -R kindashub/MBP-Mods -p Clearly-Debug-unsigned.zip`.

---

## 3. One-shot setup (recommended)

From **`ClearlyMD/`** after cloning:

```bash
chmod +x setup-clearlymd.sh install-clearlymd.sh
./setup-clearlymd.sh
```

Installs **`~/MBP-Mods/bin/clearlyedit`**, downloads the editor (if Release exists), registers Launch Services, optional **`duti`**, builds **ClearlyEdit.app** in **`~/MBP-Mods/`**.

---

## 4. Shell PATH (optional)

```bash
export PATH="$HOME/MBP-Mods/bin:$PATH"
```

Add to **`~/.zprofile`** or **`~/.zshrc`**.

---

## 5. Register ClearlyMD + default `.md` app

```bash
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
"$LSREGISTER" -f -R -trusted "$HOME/MBP-Mods/ClearlyMD.app"
```

With [duti](https://github.com/moretension/duti):

```bash
brew install duti
duti -s com.clearlymd.editor net.daringfireball.markdown all
duti -s com.clearlymd.editor public.markdown all 2>/dev/null || true
```

If Finder shows wrong icons, unregister old Markdown apps, clear icon caches, restart Finder — **`setup-clearlymd.sh`** covers the common case.

---

## 6. ClearlyEdit.app (Dock)

```bash
./build-clearlyedit-app.sh
cp -R ClearlyEdit.app "$HOME/MBP-Mods/"
```

Drag **`~/MBP-Mods/ClearlyEdit.app`** to the Dock.

---

## 7. Coexistence with TextMD

- **TextMD** → TextEdit + **`~/TextMD`**.
- **ClearlyMD** → same folder and **`TX-…`** names; different editor.
- Only one app should own **Open with** for `.md` (TextEdit vs ClearlyMD).

---

## Environment variables

| Variable | Purpose |
|----------|---------|
| `TEXTEDIT_DEFAULT_DIR` | Notes folder (default **`~/TextMD`**). |
| `TEXTEDIT_PREFIX` | Filename prefix (default **`TX`**). |
| `CLEARLYMD_APP` | Override path to **ClearlyMD.app**. |
| `CLEARLYMD_RELEASE_REPO` | Override GitHub repo for zip (default **`kindashub/MBP-Mods`**). |
| `CLEARLYMD_RELEASE_TAG` | Override tag (default **`clearlymd-latest`**). |

---

*Bundle IDs: **`com.clearlymd.editor`**, Quick Look **`com.clearlymd.editor.quicklook`**.*
