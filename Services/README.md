# Services

Registry tweaks to disable unnecessary Windows background services.
Each `.reg` file sets the target service to **Disabled**.

> **Before applying anything — create a System Restore Point.**

---

## Folders

| Folder | Description |
|--------|-------------|
| `Telemetry & Diagnostics/` | Services that send data to Microsoft in the background |
| `Gaming & Performance/` | Services that waste resources during gaming (includes SysMain, Prefetch and GameDVR/Game Bar) |
| `Xbox/` | All Xbox-related background services |
| `Privacy/` | Services that track your location or share your bandwidth |
| `Network & Legacy/` | Old or rarely useful network services |
| `Hardware/` | Services useless depending on your hardware setup |
| `User & Session/` | User account and session related services |
| `Bluetooth/` | Scripts to fully disable or re-enable Bluetooth |
