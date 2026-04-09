# SysMain & Prefetch

These two tweaks control how Windows preloads apps and data into RAM before you even open them.
They were designed to speed up slow hard drives — on modern SSDs they are unnecessary and waste resources.

---

## Should I apply these?

| Your setup | SysMain | Prefetch |
|------------|---------|----------|
| SSD (any) | ✅ Disable | ✅ Disable |
| NVMe SSD | ✅ Disable | ✅ Disable |
| HDD only | ⚠️ Keep enabled | ⚠️ Keep enabled |
| SSD + HDD | ✅ Disable | ✅ Disable |

> If your Windows drive is an SSD, disable both. Simple as that.

---

## Files

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-SysMain.reg` | SysMain service (formerly Superfetch) — preloads apps into RAM in the background | Keep enabled if your system drive is an HDD |
| `Disable-Prefetch.reg` | Windows Prefetch — preloads app data on startup | Keep enabled if your system drive is an HDD |
