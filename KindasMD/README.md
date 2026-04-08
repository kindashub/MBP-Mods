# KindasMD (macOS)

## How you run it (read first — agents and docs)

- **Normal use:** The maintainer **only** launches **`KindasMD.app`** from the Dock (or `~/MBP-Mods/KindasMD/KindasMD.app`). They do **not** open **`KindasMDEditor.app`** directly; that is implementation detail, not the everyday surface.
- **What happens:** **`KindasMD.app`** runs the Mach-O launcher, which executes **`system/kindasmd`**. That script creates a new `TX-…*.md` under `~/TextMD` and runs **`open -na`** on **`KindasMDEditor.app`** (resolution order is in **`system/kindasmd`** — it prefers **`…/KindasMD/KindasMDEditor.app`**). **`open -na` is required:** without **`-n`**, macOS reuses *any* already-running **`com.kindasmd.editor`** (often an old **Xcode/DerivedData** build), so the app you copied into **`KindasMD/`** never runs and changes look like they “do nothing”. The editor window **subtitle** shows **build number** and **MBP-Mods install** vs **DerivedData** so you can see which binary is active.
- **Double-click / Finder “open” is different:** If **KindasMD Editor is already running** (any build), macOS delivers newly opened `.md` files to **that process**. Updating **`KindasMDEditor.app`** on disk or fixing Launch Services does **not** replace a live process — you still see the old **build** in the strip (e.g. `build 4`) and an old MASTER path until you **quit** the app or run **`purge-stale-kindasmd.sh --kill-editor`** (after saving).
- **Where edits ship:** Swift UI lives under **`src/editor/`** and builds **`KindasMDEditor.app`**. For **`KindasMD.app`** to show your changes, copy the built **`KindasMDEditor.app`** to **`~/MBP-Mods/KindasMD/KindasMDEditor.app`** (or set **`KINDASMD_EDITOR_APP`**) so the Dock path and **`kindasmd`** resolve the binary you just built. **Verification = click `KindasMD.app`, not the editor bundle in Finder.**

## Master Rule 1 (always apply)

> "Understand the whole, then change the smallest correct thing. Before acting, you must be able to describe the system's purpose, constraints, and relationships completely. If an assumption could break the result, you are not ready. When acting, make the smallest change that reaches the root cause. Every element must earn its place — proliferating rules signals a failure to understand the problem."

## HARD RULE — phase-end handoff (non-negotiable)

At **every** phase **HARD STOP**, give the user a **short What's next** paste (**Finished** + **What's next**). Same template as [kindasmd_v2_roadmap.md](kindasmd_v2_roadmap.md). Build/verify lives in this README — don't paste it again at handoff.

```text
## KindasMD — what's next (paste for the user)

**Finished:** [one line — what closed this session / phase]

**What's next:** [short — only the real next work, e.g. next roadmap phase goal or the next bug; no build tutorial]

**Note:** [optional — blocker, risk, or decision]

---
Already in repo (do not repeat): @KindasMD/CONTINUATION.md · @KindasMD/README.md · @KindasMD/kindasmd_v2_roadmap.md
```

**New agent / resume work:** start at **[CONTINUATION.md](CONTINUATION.md)** (state, task, read order), then **[kindasmd_v2_roadmap.md](kindasmd_v2_roadmap.md)** — the phased build plan, HARD STOPs, and copy-paste handoff template live there.

Greenfield editor and Dock helper, built from the Clearly fork in [`src/editor/`](src/editor/) (xcodegen + Swift).

## Phased plan (authoritative)

**[kindasmd_v2_roadmap.md](kindasmd_v2_roadmap.md)** — foundation document for what we are building; read every session before substantive work.

## Apps

| Bundle | Role |
|--------|------|
| **KindasMDEditor.app** | Markdown editor (split view preserved from Clearly; Menlo; Kindas strip: box palette + MASTER folder). Built from **`src/editor/`**; keep **`~/MBP-Mods/KindasMD/KindasMDEditor.app`** in sync after build so **`kindasmd`** uses it. |
| **KindasMD.app** | **What you click every day (Dock):** runs **`system/kindasmd`**, which creates `TX-…*.md` and opens the editor. |

## Blueprint / product spec

See **[KindasMD_Blueprint.md](../KindasMD_Blueprint.md)** (repo root).

## Build (editor)

```bash
cd ~/MBP-Mods/KindasMD/src/editor
brew install xcodegen   # once
xcodegen generate
xcodebuild -scheme KindasMDEditor -configuration Debug -derivedDataPath ./build-dd build
```

Output: `build-dd/Build/Products/Debug/KindasMDEditor.app`

## Setup (launcher + defaults)

**System default for all `.md` files:** install **`duti`** (`brew install duti`), then:

```bash
cd ~/MBP-Mods/KindasMD/system
chmod +x *.sh
./setup-kindasmd.sh
```

That registers **`KindasMDEditor.app`** (`com.kindasmd.editor`) for Markdown UTI and replaces the previous ClearlyMD default. If you archived **`ClearlyMD.app`**, still run **`setup-kindasmd.sh`** so Finder and double-click `.md` open KindasMD.

### Double-click `.md` still shows an old build (subtitle / MASTER path)

1. **Running process:** Most often you still have an **old KindasMDEditor running**. **Quit** it (⌘Q all windows) or run **`./purge-stale-kindasmd.sh --kill-editor`** after saving. Then open your `.md` again — a **new** process loads the app from **`~/MBP-Mods/KindasMD/KindasMDEditor.app`**.

2. **Launch Services:** If no KindasMD process was running and Finder still opened a wrong copy, run **`./setup-kindasmd.sh`** (or **`./purge-stale-kindasmd.sh`**) so stale **`KindasMDEditor.app`** registrations (Xcode **DerivedData**, **`build-dd`**, etc.) are removed and the MBP-Mods copy is registered.

To also delete the Debug app under **`src/editor/.derivedData/.../KindasMDEditor.app`** (next **`xcodebuild`** recreates it): **`./purge-stale-kindasmd.sh --delete-derived`**.

## Split view (do not break)

Core layout lives in **`Clearly/ContentView.swift`** — the `HSplitView` / `EditorView` + `PreviewView` block is frozen unless fixing a verified bug. New UI belongs in the **Kindas strip** above the column ruler or in toolbar items.

Do not edit `ContentView`’s `HSplitView` / `EditorView` + `PreviewView` split block except for verified fixes — that is the frozen split-view surface.

## Upstream

Vendor snapshot: `KindasMD/_upstream_kindasos` (optional git clone of KindasOS). Editable sources live in **`src/editor/`** only.
