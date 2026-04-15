# 🔍 Autoruns — Sysinternals (Official from Microsoft)
**The go-to tool for auditing, optimizing, cleaning and securing everything that starts with Windows.**

Autoruns is a **free, official Microsoft tool** (Sysinternals suite), created by Mark Russinovich. Task Manager and MSCONFIG only show a fraction of what's actually running — Autoruns exposes **everything**: hidden registry keys, shell extensions, drivers, scheduled tasks, injected DLLs, Winsock providers, and much more.

> This is the tool used by power users to optimize their PC and by cybersecurity experts to track persistent malware.

<details>
<summary><b>► Show Preview Tool</b></summary>

![AutorunsTool](https://github.com/user-attachments/assets/92ee879a-c3f6-4bb1-8b28-6c1fdc8ce317)

</details>

---

## 📥 Download & Launch

1. Download `autoruns.exe` from this folder **or** directly from [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns).
2. **No installation required** — it's a portable tool, just run it directly.
3. **Right-click → Run as administrator** to get full visibility over system entries.

> [!IMPORTANT]
> Without administrator rights, Autoruns cannot see drivers, system services, and other critical entries. Always run it as admin.

---

## 🎬 Video Tutorials

Before diving in, these videos walk you through practical usage of the tool:

| Language | Creator | Link |
|----------|---------|------|
| French | [Piwi](https://github.com/Piwielle) | https://www.youtube.com/watch?v=UpTg5QbNfdc |
| English | [TroubleChute](https://www.youtube.com/@TroubleChute) | https://www.youtube.com/watch?v=rLv40VBPbXs |

---

## ⚡ Optimization (Safe Entries to Disable)

> [!WARNING]
> Only uncheck entries — never delete them. This lets you re-enable them if something breaks. When in doubt, leave it enabled.

The entries below are widely considered safe to disable on a typical desktop PC. This is not an exhaustive list — it's a conservative starting point.

---

### 🔧 Services

| Entry | Description | Why it's safe |
|-------|-------------|---------------|
| `Telemetry` | `DiagTrack`, `DiagnosticHub.StandardCollector.Service`, `dmwappushservice`, `DPS`, `WerSvc`, `wercplsupport`, `PcaSvc`, `DusmSvc` | Disables Microsoft telemetry, error reporting and compatibility data collection — no functional impact |
| `Bluetooth` | `bthserv`, `BthA2dp`, `BluetoothUserService`, `BthHFEnum`, `BthAvctpSvc` | Safe if you never use Bluetooth or don't use any Bluetooth peripherals |
| `Wi-Fi` | `WlanSvc` | Safe if you're on Ethernet only and never use Wi-Fi |

---

### 📅 Scheduled Tasks

| Entry | Description | Why it's safe |
|-------|-------------|---------------|
| `Telemetry` | 1. `\Microsoft\Windows\Application Experience\MareBackup`<br>2. `\Microsoft\Windows\Application Experience\ProgramDataUpdater`<br>3. `\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser`<br>4. `\Microsoft\Windows\Autochk\Proxy`<br>5. `\Microsoft\Windows\Customer Experience Improvement Program\*`<br>6. `\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector`<br>7. `\Microsoft\Windows\Windows Error Reporting\QueueReporting` | Pure telemetry and error reporting to Microsoft — no functional impact |
| `Bluetooth` | `\Microsoft\Windows\Bluetooth\UninstallDeviceTask` | Safe if you don't use any Bluetooth peripherals |
| `Wi-Fi` | `\Microsoft\Windows\WlanSvc\CDSSync` | Safe if you're on Ethernet only |
| `Defender` | `\Microsoft\Windows\Windows Defender\*` | **Only** if you want maximum performance and understand that Defender's background scanning is unnecessary in your setup |
---

### 🖥️ Drivers

| Entry | Description | Why it's safe |
|-------|-------------|---------------|
| `Bluetooth` | BTHUSB, BthLEEnum, BthA2dp | Safe if you don't use any Bluetooth peripherals |
| `Wi-Fi` | Netwtw, Netwtw10, RtlWlanu | Safe if you're on Ethernet only and never use Wi-Fi |
| `Defender` | WdFilter | **Only** if you use a third-party AV — never disable otherwise |

---

> [!NOTE]
> If you're unsure about an entry, right-click it in Autoruns and select **Search Online** — it will query the web for information about that specific executable.
