# MBP-Mods

**Repository:** [github.com/kindashub/MBP-Mods](https://github.com/kindashub/MBP-Mods)

macOS mods: **TextMD** (TextEdit + `~/TextMD`) and **ClearlyMD** (editor + ClearlyEdit). **ClearlyMD overview:** [`ClearlyMD/README.md`](ClearlyMD/README.md). Scripts live in each mod’s **`system/`** folder.

---

## On your Mac: only apps at the top of each mod folder

Each mod uses a **`system/`** subfolder for scripts, guides, and the **`clearlyedit`** launcher — everything you **don’t** double-click in Finder.

```
~/MBP-Mods/
├── TextMD/
│   ├── TextMD.app
│   └── system/
│       ├── TextMD-SetupGuide.md
│       └── textedit-new-md.sh
└── ClearlyMD/
    ├── ClearlyMD.app
    ├── ClearlyEdit.app
    └── system/
        ├── ClearlyMD-SetupGuide.md
        ├── clearlyedit-new-md.sh
        ├── install-clearlymd.sh
        ├── setup-clearlymd.sh
        ├── verify-clearlymd-app.sh
        ├── build-clearlyedit-app.sh
        └── clearlyedit-launcher.c
```

Repo root **`README.md`** / **`apply-to-home.sh`** exist for GitHub only — they are not required under **`~/MBP-Mods/`** itself.

```bash
./apply-to-home.sh
```

Syncs **`TextMD/`** and **`ClearlyMD/`** into **`~/MBP-Mods/`** (excludes **`ClearlyMD/system/README.md`** — GitHub index only).

---

## Guides

| Mod | Start here |
|-----|----------------|
| TextMD | [TextMD/system/TextMD-SetupGuide.md](TextMD/system/TextMD-SetupGuide.md) |
| ClearlyMD | [ClearlyMD/system/ClearlyMD-SetupGuide.md](ClearlyMD/system/ClearlyMD-SetupGuide.md) |

---

## ClearlyMD editor binary

**ClearlyMD.app** is not committed. Get **`Clearly-Debug-unsigned.zip`** from [Releases](https://github.com/kindashub/MBP-Mods/releases) tag **`clearlymd-latest`**, or run **`ClearlyMD/system/install-clearlymd.sh`**.

---

## History

- **2026-04** — **`system/`** subfolders: only **`.app`** bundles at mod root.
- **2026-04** — ClearlyMD mod; apps under **`TextMD/`** / **`ClearlyMD/`** (not `~/Applications`).
