# Services / Recommended

A collection of registry tweaks to disable unnecessary Windows services.
Each `.reg` file sets the target service `Start` value to `4` (Disabled).
Always create a **System Restore Point** before applying any of these keys.

---

## Telemetry & Diagnostics

| File | Description |
|------|-------------|
| `Disable-DiagTrack.reg` | Disables the DiagTrack service (telemetry). Lightweight version, service only. |
| `Disable-Connected-User-Telemetry.reg` | Disables DiagTrack + forces telemetry policies to 0. More complete than DiagTrack alone. Use one or the other, not both. |
| `Disable-DiagnosticPolicy.reg` | Disables automatic Windows troubleshooting (DPS). Being deprecated by Microsoft. |
| `Disable-WAPPushRouting.reg` | Disables WAP Push message routing used by Microsoft telemetry. |
| `Disable-WindowsErrorReporting.reg` | Disables automatic crash/error report sending to Microsoft. |
| `Disable-WindowsInsiderService.reg` | Disables the Windows Insider Program service. Safe if not enrolled in Insider builds. |

---

## Gaming & Performance

| File | Description |
|------|-------------|
| `Disable-GameDVR-GameBar.reg` | Disables Game DVR background recording and Game Bar overlay. Frees GPU/CPU during gaming. ⚠️ Do not apply if you use Xbox Game Bar to record clips. |
| `Disable-XboxServices.reg` | Disables Xbox-related background services bundle. ⚠️ Do not apply if you use Xbox Game Pass or Xbox Live. |
| `Disable-XboxLiveAuthManager.reg` | Disables Xbox Live authentication service. ⚠️ Do not apply if you use Xbox Game Pass or Xbox Live sign-in. |
| `Disable-XboxLiveGameSave.reg` | Disables Xbox Live cloud save sync. ⚠️ Do not apply if you rely on Xbox cloud saves. |
| `Disable-XboxAccessoryManagement.reg` | Disables Xbox wired accessory management. ⚠️ Do not apply if you use a wired Xbox controller. |
| `Disable-SearchIndexing.reg` | Disables Windows Search indexing (WSearch). Eliminates constant disk I/O. ⚠️ Windows Search bar will no longer return file results. |

---

## Privacy

| File | Description |
|------|-------------|
| `Disable-GeolocationService.reg` | Disables location sharing with apps. Breaks automatic timezone detection and Find My Device. |
| `Disable-DeliveryOptimization.reg` | Stops Windows from sharing update bandwidth with other PCs on the internet. |
| `Disable-RetailDemo.reg` | Disables the Windows Retail Demo mode service. Useless on personal PCs. |

---

## Network & Legacy Protocols

| File | Description |
|------|-------------|
| `Disable-IPHelper.reg` | Disables IPv6 tunneling (Teredo, 6to4, ISATAP). Safe on IPv4-only networks. ⚠️ May break IPv6 VPNs or DirectAccess. |
| `Disable-TCPNetBIOSHelper.reg` | Disables legacy NetBIOS over TCP/IP. Safe on all modern home networks. ⚠️ Only needed on old Windows NT domains. |
| `Disable-DistributedLinkTracking.reg` | Disables NTFS link tracking across network volumes. Safe if not on a Windows domain. |
| `Disable-FunctionDiscoveryPublication.reg` | Stops the PC from publishing itself on the local network. ⚠️ Breaks visibility in Network Explorer for other devices. |
| `Disable-RemoteRegistry.reg` | Prevents remote access to the Windows Registry. Recommended for security. |
| `Disable-MapsBroker.reg` | Disables offline maps manager. Safe if you don't use the Windows Maps app. |
| `Disable-OfflineFiles.reg` | Disables sync of network shared folders for offline access. Safe on standalone gaming PCs. |

---

## Hardware & Peripherals

| File | Description |
|------|-------------|
| `Disable-TabletInputService.reg` | Disables pen and touch input support. ⚠️ Do not apply if you use a touchscreen or stylus. |
| `Disable-WindowsBiometricService.reg` | Disables fingerprint and facial recognition (Windows Hello). ⚠️ Do not apply if you use face or fingerprint login. |
| `Disable-PrintSpooler.reg` | Disables the print spooler service. ⚠️ Do not apply if you use a printer. |
| `Disable-Fax.reg` | Disables the Fax service. Safe to disable for virtually everyone. |
| `Bluetooth/` | Registry tweaks related to Bluetooth services. See folder for details. |

---

## User & Session

| File | Description |
|------|-------------|
| `Disable-SecondaryLogon.reg` | Disables "Run as different user" functionality. Safe if you are the sole user/admin of this PC. |
| `Disable-ParentalControls.reg` | Disables Windows parental controls enforcement. Safe if you have no child accounts. |
