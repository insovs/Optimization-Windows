<img width="723" height="330" alt="image" src="https://github.com/user-attachments/assets/899361dc-2bf8-45c8-ac44-ff3688ca0d3b" />
<div align="center">

# Executable Performance Manager

A PowerShell GUI to apply system-level Windows optimizations — CPU priority, network QoS,
Firewall rules, Defender exclusions, GPU preference, and Fullscreen tweaks.
All in one place. No manual registry editing. No third-party dependencies.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey?logo=windows)
[![Discord](https://img.shields.io/badge/Support-Discord-5865F2?logo=discord&logoColor=white)](https://discord.com/invite/fayeECjdtb)
[![Preview](https://img.shields.io/badge/Video-Preview-FF0000?logo=youtube&logoColor=white)](https://youtu.be/q63XYpYXOiQ)

</div>

---

<table>
<tr>
<td align="center" width="50%">
<img width="531" height="570" alt="Splash Screen" src="https://github.com/user-attachments/assets/82179b9d-c8cd-4fde-852f-8c8e6afb454e" />
<br/><br/>
<sub><b>Splash Screen</b> — Choose a module and get started instantly.</sub>
</td>
<td align="center" width="50%">
<img width="489" height="533" alt="Main Window" src="https://github.com/user-attachments/assets/616b7091-f9f8-4a02-8ec4-111e6332c5a5" />
<br/><br/>
<sub><b>Main Window</b> — Manage your rules, add apps, and track changes in real time.</sub>
</td>
</tr>
</table>

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

---
