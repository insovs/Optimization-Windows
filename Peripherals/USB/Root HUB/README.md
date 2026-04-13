# USB Hub Power Management (disables power-saving features)

**Eliminates USB power-saving features on all hubs and controllers to ensure stable, uninterrupted and low-latency connections.**

This script targets every USB hub and controller detected on your system and disables all power management features at the registry level — selective suspend, idle power management, advanced power saving, and more.

> Used by competitive players and professionals to eliminate input latency, micro-stutters and random disconnections caused by Windows USB power management.

---

## ⚡ What it fixes

- Random disconnections and reconnections on mice, keyboards and peripherals
- Input latency spikes caused by USB power-saving delays
- Instability on USB hubs under load
- Selective suspend re-engaging after sleep or restart

---

## 🛠️ What it does

The script modifies registry keys under `HKLM:\SYSTEM\CurrentControlSet\Enum` for every USB hub and controller detected via PnP, disabling the following:

| Key | Action |
|-----|--------|
| `DisableSelectiveSuspend` | Disables selective suspend globally on USB, usbhub and usbxhci services |
| `DeviceSelectiveSuspended` | Marks device as not suspended |
| `DisablePowerMgmt` / `DisableIdlePowerMgmt` | Disables power management and idle power management |
| `SelectiveSuspendEnabled` / `EnableSelectiveSuspend` | Forces selective suspend off |
| `IdleEnable` / `IdleTimeout` | Disables idle timers |
| `LPMEnable` / `LPMState` | Disables Link Power Management |
| `AutoPowerSaveModeEnabled` / `EnableAutoSuspend` | Disables auto power saving modes |
| `RemoteWakeEnabled` / `WaitWakeEnabled` | Disables remote wake features |
| `PowerManagementEnabled` / `PMEnabled` | Disables power management entirely on the device |

---

## 📥 Download & Usage

1. Download `DisableRootHUBPowerManagement.ps1` from this folder.
2. **Right-click → Run with PowerShell** — the script will auto-elevate to administrator.

> [!CAUTION]
> If PowerShell scripts are blocked on your system, enable execution first:
> ```powershell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> Or use **[EnablePowerShellScript](https://github.com/insovs/EnablePowerShellScript)** for a one-click solution.

---

## 🎬 Video Preview

| Link |
|------|
| [Watch](https://www.youtube.com/watch?v=) |

---
