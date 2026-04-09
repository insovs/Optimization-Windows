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
