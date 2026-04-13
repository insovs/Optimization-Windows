# Telemetry & Diagnostics
Services that send data to Microsoft in the background.

| File | What it disables | Watch out |
|------|-----------------|-----------|
| `Disable-DiagTrack.reg` | Sends usage data to Microsoft | — |
| `Disable-DiagnosticPolicy.reg` | Auto troubleshooting (mostly useless) | — |
| `Disable-WAPPushRouting.reg` | Another Microsoft telemetry channel | — |
| `Disable-WindowsErrorReporting.reg` | Sends crash reports to Microsoft | — |
| `Disable-CompatTelRunner.reg` | Microsoft Compatibility Telemetry — known for random CPU spikes | — |
| `Disable-PcaSvc.reg` | Monitors every app you launch to detect compatibility issues | — |
| `Disable-Connected-User-Telemetry.reg` | Connected User Experiences & Telemetry (DiagTrack companion) | — |
| `Disable-Data-Usage-Monitoring-Service.reg` | Collects network usage statistics for Microsoft | — |
| `Disable-Windows-Error-Reporting-Control-Panel-Support.reg` | Error Reporting UI and control panel telemetry submission | — |
| `Disable-WindowsInsiderService.reg` | Windows Insider beta program service | Only needed if you are in the Insider Program |
| `Disable-DiagnosticHub.reg` | Collects performance data for Microsoft | Skip if you use Visual Studio performance profiling |
| `Disable-OnlineSpeechRecognition.reg` | Sends your voice data to Microsoft servers | Cortana voice features will stop working |
| `Disable-InkWorkspaceService.reg` | Collects data on how you type and write | Skip if you use a stylus or pen input |
