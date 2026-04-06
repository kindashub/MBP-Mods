# TextMD — Setup guide (clean macOS install)

Minimal steps to recreate the same TextEdit + `~/TextMD` workflow after reinstalling macOS. **TextEdit** is built in; no extra editor install.

**Where this bundle lives:** In the **MBP-Mods** GitHub repo: **`MBP-Mods/TextMD/`**. In KindasOS (if you use that project): **`KindasOS/MBP-Mods/TextMD/`**. You can keep a copy at **`~/MBP-Mods/TextMD/`** for backups—same files.

## What you get

- New notes as `TX-MON20260406-094222.md` under **`~/TextMD`** (English weekday + date + time).
- **Cmd+S** saves in place (no folder dialog) because each file is created on disk before opening.
- **TextEdit** opens to a **blank document** when launched without a file (no file-picker gate).
- **Plain text** defaults; no forced `.txt` suffix.
- **`.md` opens in TextEdit** if you install **`duti`** (optional).
- **`TextMD.app`** in Dock: one click → new note.

This folder contains:

| Item | Role |
|------|------|
| `TextMD.app` | Copy to `~/Applications`, add to Dock. |
| `textedit-new-md.sh` | Copy to `~/bin/textedit-new-md`, executable. |

---

## 1. Copy files into your home folder

```bash
mkdir -p "$HOME/bin" "$HOME/Applications" "$HOME/TextMD"
cp "/path/to/this/folder/textedit-new-md.sh" "$HOME/bin/textedit-new-md"
chmod +x "$HOME/bin/textedit-new-md"
cp -R "/path/to/this/folder/TextMD.app" "$HOME/Applications/"
```

Replace `/path/to/this/folder` with the real path to this `TextMD` directory (e.g. after cloning **MBP-Mods** or restoring from backup).

---

## 2. Shell PATH

Add to `~/.zprofile` (or `~/.zshrc`):

```bash
export PATH="$HOME/bin:$PATH"
```

Open a new Terminal window (or `source` the file).

---

## 3. TextEdit defaults (Terminal)

```bash
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
defaults write com.apple.TextEdit RichText -bool false
defaults write com.apple.TextEdit AddExtensionToNewPlainTextFiles -bool false
```

Quit TextEdit fully (**Cmd+Q**) if it was open, then continue.

---

## 4. Default app for `.md` (optional)

```bash
brew install duti
duti -s com.apple.TextEdit net.daringfireball.markdown all
```

Or: Finder → any `.md` → **Get Info** → **Open with** → TextEdit → **Change All…**

---

## 5. TextEdit Settings (optional)

**TextEdit → Settings → New Document:** monospace font (Monaco, Menlo, or Courier) if you care about ASCII alignment.

---

## 6. Dock

Drag **`~/Applications/TextMD.app`** to the Dock. First run may show a security prompt (right-click → Open once if needed).

---

## Alternative: KindasOS repo on disk

If you have the **KindasOS** repository on disk, from the repo root run:

```bash
./scripts/setup-textedit-default.sh
```

That applies the same `defaults`, creates `~/TextMD`, installs `~/bin/textedit-new-md` from the repo script, rebuilds `~/Applications/TextMD.app`, and runs `duti` if installed. Still copy **`TextMD.app` from this folder** if you want the exact bundled applet; otherwise the script regenerates it.

---

## Open the notes folder from TextEdit

**Cmd-click** (or right-click) the **filename in the title bar** → choose the **`TextMD`** folder in the path menu. Or pin **`~/TextMD`** in Finder’s sidebar / Dock.

---

*Filename pattern: `TX-<WDAY><YYYYMMDD>-<HHMMSS>.md` with `LC_ALL=C` weekday (MON–SUN). Override: `TEXTEDIT_DEFAULT_DIR`, `TEXTEDIT_PREFIX` env vars on `textedit-new-md.sh`.*
