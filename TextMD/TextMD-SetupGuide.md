# TextMD — Setup guide (clean macOS install)

Minimal steps to recreate the TextEdit + `~/TextMD` workflow after reinstalling macOS. **TextEdit** is built in; no extra editor install.

**This bundle** lives in **`TextMD/`** in [MBP-Mods](https://github.com/kindashub/MBP-Mods). On your Mac, keep the same structure:

```
~/MBP-Mods/TextMD/
├── TextMD.app              ← Dock helper (optional)
├── textedit-new-md.sh
└── TextMD-SetupGuide.md    ← this file
```

## What you get

- New notes as `TX-MON20260406-094222.md` under **`~/TextMD`** (English weekday + date + time).
- **Cmd+S** saves in place (no folder dialog) because each file is created on disk before opening.
- **TextEdit** opens to a **blank document** when launched without a file.
- **Plain text** defaults; no forced `.txt` suffix.
- **`.md` opens in TextEdit** if you install **`duti`** (optional).
- **`TextMD.app`** in Dock (inside **`~/MBP-Mods/TextMD/`**): one click → new note.

| Item | Role |
|------|------|
| `TextMD.app` | Lives in **`~/MBP-Mods/TextMD/`** — add to Dock from there. |
| `textedit-new-md.sh` | Copy to **`~/bin/textedit-new-md`**, `chmod +x` (or run by full path). |

---

## 1. Copy into your home folder

```bash
mkdir -p "$HOME/bin" "$HOME/MBP-Mods/TextMD" "$HOME/TextMD"
cp "/path/to/TextMD/textedit-new-md.sh" "$HOME/bin/textedit-new-md"
chmod +x "$HOME/bin/textedit-new-md"
cp -R "/path/to/TextMD/TextMD.app" "$HOME/MBP-Mods/TextMD/"
```

Use the real path to this **`TextMD`** folder (e.g. after `./apply-to-home.sh` from a repo clone).

**Do not** put `TextMD.app` in **`~/Applications`** — keep it under **`~/MBP-Mods/TextMD/`** so it stays next to the scripts, matching this repository.

---

## 2. Shell PATH

Add to `~/.zprofile` (or `~/.zshrc`):

```bash
export PATH="$HOME/bin:$PATH"
```

---

## 3. TextEdit defaults (Terminal)

```bash
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
defaults write com.apple.TextEdit RichText -bool false
defaults write com.apple.TextEdit AddExtensionToNewPlainTextFiles -bool false
```

Quit TextEdit fully (**Cmd+Q**) if it was open.

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

Drag **`~/MBP-Mods/TextMD/TextMD.app`** to the Dock. First run may require **right-click → Open** once.

---

## Open the notes folder from TextEdit

**Cmd-click** (or right-click) the **filename in the title bar** → choose **`TextMD`** in the path menu. Or pin **`~/TextMD`** in Finder’s sidebar / Dock.

---

*Filename pattern: `TX-<WDAY><YYYYMMDD>-<HHMMSS>.md` with `LC_ALL=C` weekday (MON–SUN). Override: `TEXTEDIT_DEFAULT_DIR`, `TEXTEDIT_PREFIX` on `textedit-new-md.sh`.*
