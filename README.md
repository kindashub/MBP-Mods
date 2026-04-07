# MBP-Mods

**Repository:** [github.com/kindashub/MBP-Mods](https://github.com/kindashub/MBP-Mods)

macOS host-only bundles: **TextMD** (TextEdit + `~/TextMD`) and **ClearlyMD** (markdown editor + ClearlyEdit). Everything you need to build, install, and restore is documented **here** — not as loose files in your home folder.

---

## On your Mac: folder layout (matches this repo)

Use **`~/MBP-Mods/`** only as a **container** for two sibling mod folders. **Do not** keep a full git clone of this repo in `~/MBP-Mods` unless you want Git metadata there; preferred workflow is below.

```
~/MBP-Mods/
├── TextMD/
│   ├── TextMD.app              ← Dock helper (AppleScript)
│   ├── textedit-new-md.sh
│   └── TextMD-SetupGuide.md
└── ClearlyMD/
    ├── ClearlyMD.app           ← editor (from Release zip, or build elsewhere)
    ├── ClearlyEdit.app         ← Dock helper (run build-clearlyedit-app.sh)
    ├── clearlyedit-new-md.sh   → install as clearlyedit next to apps (see guide)
    ├── install-clearlymd.sh
    ├── setup-clearlymd.sh
    ├── build-clearlyedit-app.sh
    └── ClearlyMD-SetupGuide.md
```

**No** `README.md` or `CHANGELOG.md` is required under `~/MBP-Mods/` — those exist only **on GitHub**. To populate your Mac without copying repo root files:

```bash
# From a clone of this repository (any path):
./apply-to-home.sh
```

That rsyncs **only** `TextMD/` and `ClearlyMD/` into `~/MBP-Mods/`. Then open each folder’s `*-SetupGuide.md` and run any one-time scripts.

---

## Mod guides (source of truth)

| Mod | Guide |
|-----|--------|
| TextEdit + `~/TextMD` | [TextMD/TextMD-SetupGuide.md](TextMD/TextMD-SetupGuide.md) |
| ClearlyMD + ClearlyEdit | [ClearlyMD/ClearlyMD-SetupGuide.md](ClearlyMD/ClearlyMD-SetupGuide.md) |

---

## ClearlyMD editor binary

The **ClearlyMD.app** bundle is **not** committed (large). It is published as **`Clearly-Debug-unsigned.zip`** on **this repo’s** [Releases](https://github.com/kindashub/MBP-Mods/releases), tag **`clearlymd-latest`**. Unzip → **`Clearly.app`** → install as **`~/MBP-Mods/ClearlyMD/ClearlyMD.app`**. Script: **`ClearlyMD/install-clearlymd.sh`**.

---

## History

- **2026-04** — ClearlyMD mod added; layout: apps live **inside** `TextMD/` and `ClearlyMD/` folders (not `~/Applications` or flat under `~/MBP-Mods`).
- **2026-04** — Repository skeleton + TextMD mod.
