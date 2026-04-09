# Services / Recommended

These registry tweaks disable unnecessary Windows background services to improve performance and privacy.
Double-click any `.reg` file and confirm to apply it. **Create a Restore Point first** just in case.

---

## Telemetry & Diagnostics
*Services that send data to Microsoft in the background.*

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-DiagTrack.reg` | Sends usage data to Microsoft | (Recommended) |
| `Disable-Connected-User-Telemetry.reg` | Same as above but more complete. Use this one instead of DiagTrack | (Recommended) |
| `Disable-DiagnosticPolicy.reg` | Auto troubleshooting (mostly useless) | (Recommended) |
| `Disable-WAPPushRouting.reg` | Another Microsoft telemetry channel | (Recommended) |
| `Disable-WindowsErrorReporting.reg` | Sends crash reports to Microsoft | (Recommended) |
| `Disable-WindowsInsiderService.reg` | Windows Insider beta program service | Only needed if you are in the Insider Program |

---

## Gaming & Performance
*Services that waste GPU/CPU/RAM for most users.*

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-GameDVR-GameBar.reg` | Background game recording (Win+G overlay) | Skip if you record clips with Xbox Game Bar |
| `Disable-XboxServices.reg` | Xbox background services | (Recommended) Skip if you use Xbox Game Pass |
| `Disable-XboxLiveAuthManager.reg` | Xbox Live login service | Skip if you use Xbox Game Pass |
| `Disable-XboxLiveGameSave.reg` | Xbox cloud save sync | Skip if you use Xbox cloud saves |
| `Disable-XboxAccessoryManagement.reg` | Xbox wired accessory driver | Skip if you use a wired Xbox controller |
| `Disable-SearchIndexing.reg` | Constant background disk indexing | Windows Search bar won't find files anymore |

---

## Privacy
*Services that track your location or share your bandwidth.*

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-GeolocationService.reg` | Location access for apps | Automatic timezone detection will stop working |
| `Disable-DeliveryOptimization.reg` | Uses your internet to distribute Windows updates to other PCs | — |
| `Disable-RetailDemo.reg` | Windows store demo mode | — |

---

## Network & Legacy
*Old or rarely useful network services.*

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-IPHelper.reg` | IPv6 tunneling | Skip if your VPN uses IPv6 |
| `Disable-TCPNetBIOSHelper.reg` | Very old Windows network protocol | — |
| `Disable-DistributedLinkTracking.reg` | Tracks file shortcuts across network drives | — |
| `Disable-FunctionDiscoveryPublication.reg` | Makes your PC visible to others on local network | Skip if you share files between PCs |
| `Disable-RemoteRegistry.reg` | Remote access to your registry | — |
| `Disable-MapsBroker.reg` | Windows Maps offline sync | — |
| `Disable-OfflineFiles.reg` | Syncs network folders for offline use | Skip if you work with network drives |

---

## Hardware
*Services useless depending on your setup.*

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-TabletInputService.reg` | Touch and pen input | Skip if you have a touchscreen |
| `Disable-WindowsBiometricService.reg` | Fingerprint and face recognition | Skip if you use Windows Hello |
| `Disable-PrintSpooler.reg` | Printer service | Skip if you use a printer |
| `Disable-Fax.reg` | Fax service | — |
| `Bluetooth/` | Bluetooth-related tweaks | See folder |

---

## User & Session

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-SecondaryLogon.reg` | Run as different user option | — |
| `Disable-ParentalControls.reg` | Parental controls enforcement | Skip if you have child accounts on this PC |
