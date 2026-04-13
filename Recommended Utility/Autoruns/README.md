# 🔍 Autoruns — Sysinternals (Official from Microsoft)
**The go-to tool for auditing, optimizing, cleaning and securing everything that starts with Windows.**

Autoruns is a **free, official Microsoft tool** (Sysinternals suite), created by Mark Russinovich. Task Manager and MSCONFIG only show a fraction of what's actually running — Autoruns exposes **everything**: hidden registry keys, shell extensions, drivers, scheduled tasks, injected DLLs, Winsock providers, and much more.

> This is the tool used by power users to optimize their PC and by cybersecurity experts to track persistent malware.

---

## 📥 Download & Launch

1. Download `autoruns.exe` from this folder **or** directly from [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns)
2. **No installation required** — it's a portable tool, just run it directly
3. **Right-click → Run as administrator** to get full visibility over system entries

> [!IMPORTANT]
> Without administrator rights, Autoruns cannot see drivers, system services, and other critical entries. Always run it as admin.

---

## 🎬 Video Tutorials

Before diving in, these videos walk you through practical usage of the tool:

| Language | Creator | Link |
|----------|---------|------|
| 🇫🇷 French | [Piwi](https://github.com/Piwielle) | [Watch](https://www.youtube.com/watch?v=UpTg5QbNfdc) |
| 🇬🇧 English | [TroubleChute](https://www.youtube.com/@TroubleChute) | [Watch](https://www.youtube.com/watch?v=rLv40VBPbXs) |

---

## ⚡ Optimization — Safe Entries to Disable

> [!WARNING]
> Only uncheck entries — never delete them. This lets you re-enable them if something breaks. When in doubt, leave it enabled.

The entries below are widely considered safe to disable on a typical desktop PC. This is not an exhaustive list — it's a conservative starting point.

### 🔧 Services

| Entry | Description | Why it's safe |
|-------|-------------|---------------|
| `DiagTrack` | Connected User Experiences and Telemetry | Microsoft telemetry — no impact on functionality |
| `WSearch` | Windows Search | Disables file indexing; search still works, just slower on first use |
| `SysMain` (Superfetch) | Memory preloading | Redundant on SSDs; can cause unnecessary disk activity |
| `Fax` | Fax service | Useful only if you use a fax modem |

### 📅 Scheduled Tasks

| Entry | Description | Why it's safe |
|-------|-------------|---------------|
| `Microsoft\Windows\Customer Experience Improvement Program\*` | CEIP telemetry tasks | Pure telemetry, no functional impact |
| `Microsoft\Windows\Autochk\Proxy` | Error reporting proxy | Part of the error reporting system, not essential |
| `Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector` | Disk telemetry collection | Data collection only, no diagnostic function |

### 🖥️ Drivers

| Entry | Description | Why it's safe |
|-------|-------------|---------------|
| `dmwappushservice` | WAP Push Message Routing | Telemetry-related, not needed on desktop |

> [!NOTE]
> More entries will be added here over time. If you're unsure about an entry, right-click it in Autoruns and select **Search Online** — it will query the web for information about that specific executable.
