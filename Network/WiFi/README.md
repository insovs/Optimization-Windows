# WiFi

**DisableWiFi.bat** – Completely disables WiFi.
**EnableWiFi.bat** – Restores WiFi (services, tasks, adapters).

---

## Features (Disable)

* Stops & disables WiFi services: `WlanSvc`, `vwififlt`, `Wcmsvc`
* Disables scheduled WiFi tasks: `WiFiTask`, `CDSSync`, `MoProfileManagement`, `NotificationTask`, `OobeDiscovery`
* Disables all PnP WiFi adapters via PowerShell
* Optional restart to apply changes

---

## Usage

1. **Run as Administrator with PowerRun.exe**
2. Confirm action (`y`)
3. Restart to finalize

> **Note:** Only use if primarily on wired Ethernet. Re-enable with **EnableWiFi.bat** if necessary.

---
