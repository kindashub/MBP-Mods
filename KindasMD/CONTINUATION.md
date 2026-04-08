# KindasMD — continue here

**Dock-only workflow:** The maintainer **only** clicks **`KindasMD.app`** (not **`KindasMDEditor.app`**). **`system/kindasmd`** opens the editor; sync the built **`KindasMDEditor.app`** to **`~/MBP-Mods/KindasMD/KindasMDEditor.app`** so that path matches **[README.md](README.md)** (*How you run it*). Verify by Dock launch.

## Master Rule 1 (always apply)

> "Understand the whole, then change the smallest correct thing. Before acting, you must be able to describe the system's purpose, constraints, and relationships completely. If an assumption could break the result, you are not ready. When acting, make the smallest change that reaches the root cause. Every element must earn its place — proliferating rules signals a failure to understand the problem."

## HARD RULE — phase-end handoff (non-negotiable)

At **every** phase **HARD STOP**, give the user **one short paste**: **Finished** + **What's next** — [same fence](kindasmd_v2_roadmap.md) as the roadmap (top + end of each phase). Everything else (build, verify, read order) is **already** in this file and README; don't repeat it in chat.

```text
## KindasMD — what's next (paste for the user)

**Finished:** [one line — what closed this session / phase]

**What's next:** [short — only the real next work, e.g. next roadmap phase goal or the next bug; no build tutorial]

**Note:** [optional — blocker, risk, or decision]

---
Already in repo (do not repeat): @KindasMD/CONTINUATION.md · @KindasMD/README.md · @KindasMD/kindasmd_v2_roadmap.md
```

**Use this file as the single landing page for a new agent.** Paste `@KindasMD/CONTINUATION.md` (or open this path) first, then follow the order below.

## Read order

1. **Rules at the top of this file** — Master Rule 1 + HARD RULE + short **What's next** paste template.
2. **This file (rest)** — state + next task.
3. **[kindasmd_v2_roadmap.md](kindasmd_v2_roadmap.md)** — **canonical phased plan** (phases, HARD STOPs, handoff repeated every phase, failure modes). Required for cold start; do not skip.
4. [README.md](README.md) — layout, build, setup.
5. [KindasMD_Blueprint.md](../KindasMD_Blueprint.md) — product behavior.
6. Optional: Cursor may mirror the same content as `~/.cursor/plans/kindasmd_v2_roadmap_*.plan.md` — if in doubt, **the repo file wins**.

## Current state (update after every chunk)

- **Editor:** Swift Clearly fork in `src/editor/` → **KindasMDEditor** (`com.kindasmd.editor`). Menlo; **Kindas strip** = box grid (copy / edit squares) + **MASTER** (`~/TextMD/MASTER`) load/save.
- **Dock:** `KindasMD.app` (`com.kindasmd.dock`) + `system/kindasmd` — same pattern as ClearlyMD. **User verification is always via `KindasMD.app`**; keep **`KindasMD/KindasMDEditor.app`** updated after builds.
- **Split view:** Minimal changes; scroll sync uses **ScrollSyncRelay** + **ScrollBridge** extensions (upstream snapshot was incomplete).
- **Apps on disk:** `KindasMDEditor.app` and `KindasMD.app` under this folder after build + copy (see README).
- **Roadmap:** Canonical **[kindasmd_v2_roadmap.md](kindasmd_v2_roadmap.md)** in this folder (phases, HARD STOPs, cold-start handoff template). Prefer it over any Cursor-only plan copy.
- **Rules docs:** **Master Rule 1** + **HARD RULE** (short **What's next** paste: **Finished** + **What's next** only) at top of this file, [README.md](README.md), [kindasmd_v2_roadmap.md](kindasmd_v2_roadmap.md), and [repo README.md](../README.md).
- **Last verification (2026-04-08):** `xcodebuild` KindasMDEditor **Debug** OK; `system/verify-kindasmd-editor.sh` **exit 0** (executable `KindasMDEditor`, bundle id `com.kindasmd.editor`). Dock script **`system/kindasmd`** smoke-tested with `TEXTEDIT_DEFAULT_DIR` → creates `TX-*-YYYYMMDD-HHMMSS.md` and runs `open -a` on `~/MBP-Mods/KindasMD/KindasMDEditor.app`. Strip behaviors confirmed in code: box tap → `NSPasteboard`; `kindasBoxGridCells` **UserDefaults** persistence; **MASTER** reads/writes `.md` under `~/TextMD/MASTER`. Split + scroll sync wiring unchanged (**`editorPreviewScrollSync`**, `ScrollSyncRelay` / `ScrollBridge`); interactive UI smoke left to manual check.

## Next agent — your task (EDIT BEFORE EACH HANDOFF)

**TASK:** Resume from **Current state**, [kindasmd_v2_roadmap.md](kindasmd_v2_roadmap.md), and [KindasMD_Blueprint.md](../KindasMD_Blueprint.md). Last run (2026-04-08): full verification pass completed — see **CHANGELOG.md** and **Current state** bullet “Last verification”.

**Do not:** Refactor split-view core without a verified bug; change bundle IDs casually (`com.kindasmd.*`).

## Quick commands

```bash
cd ~/MBP-Mods/KindasMD/src/editor && xcodegen generate && xcodebuild -scheme KindasMDEditor -configuration Debug -derivedDataPath ./build-dd -destination 'platform=macOS' build
cp -R ./build-dd/Build/Products/Debug/KindasMDEditor.app ~/MBP-Mods/KindasMD/
```

```bash
~/MBP-Mods/KindasMD/system/verify-kindasmd-editor.sh
```

## Changelog

Project-level notes: add **`CHANGELOG.md`** in this folder when you want a running ledger; until then, append **“Last closed / Next”** under **Current state** above.
