# ClearlyMD setup (short)

See **`../README.md`** for architecture and the KindasOS release URL.

```bash
cd ~/MBP-Mods/ClearlyMD/system
./install-clearlymd.sh    # ClearlyMD.app from kindashub/KindasOS Release clearlymd-latest
./setup-clearlymd.sh      # launcher, duti, ClearlyEdit.app, Launch Services
./verify-clearlymd-app.sh # sanity-check ClearlyMD.app
```

**`brew install duti`** is required for system-wide `.md` → ClearlyMD.

Rebuild Dock helper only:

```bash
./build-clearlyedit-app.sh
```
