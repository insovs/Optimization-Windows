# Disable ETW / AutoLogger Traces for Windows

This script is designed to **disable all Windows ETW auto-loggers** (Event Tracing for Windows) to reduce background logging, which can improve system performance and latency.

> **⚠ Warning:** Disabling these loggers may affect diagnostics, monitoring, and troubleshooting. Only use this script if you understand the implications or prioritize maximum performance above all else.

---

## Features

* Disables all Windows ETW auto-loggers via registry tweaks
* Reduces background logging overhead
* Improves system performance and lowers latency
 

---



## Usage

1. **Backup your system:**
   Create a system restore point before running this script.

2. **Run with PowerRun:**
   To ensure all changes are applied correctly, run the script via PowerRun.
   The script automatically relaunches itself as **TrustedInstaller** if not already.



---

## Auto-Loggers Disabled

The script disables the following auto-loggers:

* AppModel
* AutoLogger-Diagtrack-Listener
* Cellcore
* Circular Kernel Context Logger
* CloudExperienceHostOobe
* DataMarket
* DefenderApiLogger
* DefenderAuditLogger
* EventLog-Security
* EventLog-System
* HolographicDevice
* LwtNetLog
* Mellanox-Kernel
* Microsoft-Windows-AssignedAccess
* Microsoft-Windows-Rdp-Graph
* Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace
* Microsoft-Windows-Setup
* NBSMBLOGGER
* NetCore
* NtfsLog
* PEAuthLog
* RadioMgr
* RdrLog
* ReadyBoot
* SetupPlatform
* SetupPlatformTel
* SpoolerLogger
* SQMLogger
* TCPIPLOGGER
* TileStore
* Tpm
* UBPM
* WdiContextLog
* WFP-IPsec Trace
* WiFiDriverHVSession
* WiFiDriverHVSessionRepro
* WinPhoneCritical
* DiagLog
* EventLog-Application
* Diagtrack-Listener
* WiFiSession
 

---

## References

* [Microsoft Docs: Configuring and starting an AutoLogger session](https://learn.microsoft.com/en-us/windows/win32/etw/configuring-and-starting-an-autologger-session)

---
