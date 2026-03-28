<div align="center">

# ⚡ Performance Manager

**System-level optimizations for Windows — games and applications**
**Performance Manager** is a dark-themed WPF GUI built entirely in PowerShell that lets you apply low-level Windows optimizations to any game or application.

It features a splash screen with quick-access shortcuts and a full sidebar navigation across 7 optimization modules, all manageable from a single interface. Every option is designed to improve performance and reduce latency.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey?logo=windows)
[![Discord](https://img.shields.io/badge/Support-Discord-5865F2?logo=discord&logoColor=white)](https://discord.com/invite/fayeECjdtb)
[![Preview](https://img.shields.io/badge/Video-Preview-FF0000?logo=youtube&logoColor=white)](https://youtu.be/q63XYpYXOiQ)

</div>

---

## ✨ Features

| Module | What it does |
|---|---|
| 🧠 **CPU Priority** | Sets `CpuPriorityClass=3` (High) and `IoPriority=3` (High) via IFEO. Windows schedules the process with elevated CPU and disk access priority at every launch, ensuring system resources are prioritized for your executable. |
| 🌐 **QoS Network** | Assigns DSCP 46 (Expedited Forwarding) to the selected app via Windows QoS policy. Your router processes its packets first, drastically reducing ping and jitter. |
| 🎮 **GPU Preference** | Forces `GpuPreference=2` (High Performance / discrete GPU) for the selected executable. Useful on laptops with hybrid GPU setups (Intel + NVIDIA). |
| 🛡️ **Run As Admin** | Configures an app to always launch with administrator privileges via `AppCompatFlags` + IFEO — ensuring better compatibility and resource access for the executable. |
| 🔥 **Firewall** | Creates explicit Inbound + Outbound Allow rules in Windows Firewall for the selected executable, preventing connection blocks and reducing packet loss. |
| 🛡️ **Defender** | Adds the game or app folder to Windows Defender's exclusion list, preventing real-time background scans from causing stutter or frame drops during gameplay. |
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

### Run

```powershell
# Right-click → Run with PowerShell
```

> The script automatically detects if it is not running as administrator and relaunches itself elevated.

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
| Fullscreen — system-wide | `HKCU:\System\GameConfigStore` |
| Fullscreen — per-app | `HKCU:\System\GameConfigStore\Children\<GUID>` |

All changes are **non-destructive** and can be removed from within the app using the **Delete selected** button on each page.

---

## ⚠️ Notes

- **Windows Defender module** will display a warning banner if Defender is unavailable (disabled by a third-party AV, service not running, etc.) with a detailed explanation of the cause.
- **Run As Admin**: some apps may refuse to launch when this flag is set — remove the rule if that happens.
- **FSO (Fullscreen Optimizations)**: system-wide disable writes to `GameConfigStore`. Per-app disable creates a child key under `GameConfigStore\Children` with a unique GUID and the executable path.
- All registry operations are reversible. No system files are modified.

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
