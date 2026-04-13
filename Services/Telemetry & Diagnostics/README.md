# Telemetry & Diagnostics

> [!NOTE]
> Services that send data to Microsoft in the background. **Recommended to disable**.

| File | Watch out |
|------|-----------|
| `Disable-DiagTrack.reg` | Feedback Hub app will stop working |
| `Disable-DiagnosticPolicy.reg` | Windows built-in troubleshooters will stop working |
| `Disable-WindowsErrorReporting.reg` | Crash dumps and error logs will no longer be sent — irrelevant for most users |
| `Disable-WindowsInsiderService.reg` | Only needed if you are in the Insider Program |
| `Disable-PcaSvc.reg` | Windows may stop warning you about incompatible apps |
| `Disable-DiagnosticHub.reg` | Skip if you use Visual Studio performance profiling |
| `Disable-OnlineSpeechRecognition.reg` | Cortana voice features will stop working |
| `Disable-InkWorkspaceService.reg` | Skip if you use a stylus or pen input |
| `Disable-Connected-User-Telemetry.reg` | Feedback Hub app will stop working |
| `Disable-Data-Usage-Monitoring-Service.reg` | Windows Settings → Network → Data Usage will no longer update |
| `Disable-Windows-Error-Reporting-Control-Panel-Support.reg` | The "Problem Reports" section in Control Panel will stop working |
| `Disable-WAPPushRouting.reg` | — |
| `Disable-CompatTelRunner.reg` | — |
