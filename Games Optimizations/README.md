<div align="center">

# ⚡ Performance Manager

**System-level optimizations for Windows — games and applications**

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey?logo=windows)
![Admin](https://img.shields.io/badge/Requires-Admin-red)
![License](https://img.shields.io/badge/License-MIT-green)

</div>

---

## 📋 Overview

**Performance Manager** is a dark-themed WPF GUI built entirely in PowerShell that lets you apply low-level Windows optimizations to any game or application — without touching the registry or Group Policy manually.

It features a splash screen with quick-access shortcuts and a full sidebar navigation across 7 optimization modules, all manageable from a single interface.

---

## ✨ Features

| Module | What it does |
|---|---|
| 🧠 **CPU Priority** | Sets `CpuPriorityClass=3` (High) and `IoPriority=3` (High) via IFEO. Windows schedules the process with elevated CPU and disk access priority at every launch. |
| 🌐 **QoS Network** | Assigns DSCP 46 (Expedited Forwarding) to the selected app via Windows QoS policy. Your router processes its packets first, reducing ping spikes and jitter. |
| 🎮 **GPU Preference** | Forces `GpuPreference=2` (High Performance / discrete GPU) for the selected executable. Useful on laptops with hybrid GPU setups (Intel + NVIDIA). |
| 🛡️ **Run As Admin** | Configures an app to always launch with administrator privileges via `AppCompatFlags` + IFEO — without needing a UAC prompt each time. |
| 🔥 **Firewall** | Creates explicit Inbound + Outbound Allow rules in Windows Firewall for the selected executable, preventing connection blocks and reducing packet loss. |
| 🛡️ **Defender** | Adds the game/app folder to Windows Defender's exclusion list, preventing real-time scans from causing stutter or frame drops during gameplay. |
| 🖥️ **Fullscreen Optimization** | Disables Windows Fullscreen Optimizations (FSO) system-wide or per-app. Forces true exclusive fullscreen for lower input latency and better frame pacing. |

---

## 🖼️ Interface

The app opens with a **splash screen** listing all available modules. Clicking a module takes you directly to its configuration page.

The main window features:
- A **sidebar navigation** with 7 pages
- A **scrollable content area** per page with explanations, add buttons, and a list of active rules
- A **status bar** with live feedback on every action
- Full **window resizing** support
- A custom dark theme with no window chrome (frameless WPF window)

---

## 🚀 Getting Started

### Requirements

- Windows 10 / 11
- PowerShell 5.1 or later
- Administrator privileges (the script auto-elevates itself)

### Run

```powershell
# Right-click → Run with PowerShell
# OR from an admin terminal:
powershell -ExecutionPolicy Bypass -File "PerformanceManager.ps1"
```

> The script detects if it's not running as admin and relaunches itself elevated automatically.

---

## 🔧 How it works

All settings are written directly to the Windows registry or managed via built-in PowerShell cmdlets:

| Feature | Registry / API used |
|---|---|
| CPU Priority | `HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\<exe>\PerfOptions` |
| QoS | `HKLM:\SOFTWARE\Policies\Microsoft\Windows\QoS` |
| GPU Preference | `HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences` |
| Run As Admin | `HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers` |
| Firewall | `New-NetFirewallRule` cmdlet |
| Defender | `Add-MpPreference -ExclusionPath` cmdlet |
| Fullscreen (FSO) | `HKCU:\System\GameConfigStore` |

All changes are **non-destructive** and can be removed from within the app using the "Delete selected" button on each page.

---

## ⚠️ Notes

- **Windows Defender module** will display a warning banner if Defender is unavailable (disabled by a third-party AV, service not running, etc.) with a detailed explanation of the cause.
- **Run As Admin**: some apps may refuse to launch when this flag is set — remove the rule if that happens.
- **FSO (Fullscreen Optimizations)**: system-wide disable writes to `GameConfigStore`. Per-app disable creates a child key with the executable path.
- All registry operations are reversible. No system files are modified.

---

## 📁 Structure

```
PerformanceManager.ps1   ← Single-file script, no dependencies
```

No installation required. No configuration files. Everything is self-contained.

---

## 🤝 Contributing

Pull requests are welcome. If you find a bug or want to suggest a new optimization module, feel free to open an issue.

---

## 👤 Author

**insovs** — [github.com/insovs](https://github.com/insovs)

---

<div align="center">
<sub>Built with PowerShell + WPF · No external dependencies · 100% native Windows APIs</sub>
</div>
