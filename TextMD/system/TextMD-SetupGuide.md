# TextMD — Setup guide (clean macOS install)

Minimal steps to recreate the TextEdit + `~/TextMD` workflow after reinstalling macOS. **TextEdit** is built in; no extra editor install.

**This mod’s folder** has only **`TextMD.app`** at the top level (what you click in Finder). Scripts and this guide live in **`system/`**.

```
~/MBP-Mods/TextMD/
├── TextMD.app
└── system/
    ├── TextMD-SetupGuide.md
    └── textedit-new-md.sh
```

## What you get

- New notes as `TX-MON20260406-094222.md` under **`~/TextMD`**.
- **Cmd+S** saves in place (no folder dialog).
- **TextEdit** blank on launch; plain text; optional **`duti`** for `.md` → TextEdit.
- **`TextMD.app`** in Dock — runs **`~/bin/textedit-new-md`** (install launcher from **`system/textedit-new-md.sh`**).

---

## 1. Copy launcher and Dock app

```bash
mkdir -p "$HOME/bin" "$HOME/MBP-Mods/TextMD" "$HOME/TextMD"
cp "$HOME/MBP-Mods/TextMD/system/textedit-new-md.sh" "$HOME/bin/textedit-new-md"
chmod +x "$HOME/bin/textedit-new-md"
```

**TextMD.app** should already be **`~/MBP-Mods/TextMD/TextMD.app`** (from this repo). Add it to the Dock from there — not under **`~/Applications`**.

---

## 2. Shell PATH

```bash
export PATH="$HOME/bin:$PATH"
```

Add to `~/.zprofile` or `~/.zshrc`.

---

## 3. TextEdit defaults (Terminal)

```bash
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
defaults write com.apple.TextEdit RichText -bool false
defaults write com.apple.TextEdit AddExtensionToNewPlainTextFiles -bool false
```

Quit TextEdit fully (**Cmd+Q**).

---

## 4. Default app for `.md` (optional)

```bash
brew install duti
duti -s com.apple.TextEdit net.daringfireball.markdown all
```

---

## 5. Dock

Drag **`~/MBP-Mods/TextMD/TextMD.app`** to the Dock.

---

## Open `~/TextMD` from TextEdit

**Cmd-click** the filename in the title bar → pick the **TextMD** folder, or pin **`~/TextMD`** in Finder.

---

*Pattern: `TX-<WDAY><YYYYMMDD>-<HHMMSS>.md`. Override: `TEXTEDIT_DEFAULT_DIR`, `TEXTEDIT_PREFIX`.*
