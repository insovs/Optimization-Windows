# Telemetry & Diagnostics
> [!NOTE]
> Services that send data to Microsoft in the background. **Recommended to disable**.

| File | Service Name | Service Key | Watch out |
|------|-------------|-------------|-----------|
| `Disable-Connected-User-Experiences-and-Telemetry.reg` | Connected User Experiences and Telemetry | `DiagTrack` | Feedback Hub app will stop working |
| `Disable-DiagnosticPolicy.reg` | Diagnostic Policy Service | `DPS` | Windows built-in troubleshooters will stop working |
| `Disable-WindowsErrorReporting.reg` | Windows Error Reporting Service | `WerSvc` | Crash dumps and error logs will no longer be sent — irrelevant for most users |
| `Disable-WindowsInsiderService.reg` | Windows Insider Service | `wisvc` | Only needed if you are in the Insider Program |
| `Disable-Compatibility-Assistant-Service.reg` | Program Compatibility Assistant | `PcaSvc` | Windows may stop warning you about incompatible apps |
| `Disable-DiagnosticHub.reg` | Microsoft Diagnostics Hub Standard Collector | `diagnosticshub.standardcollector.service` | Skip if you use Visual Studio performance profiling |
| `Disable-OnlineSpeechRecognition.reg` | Online Speech Recognition | *(registry only)* | Cortana voice features will stop working |
| `Disable-InkWorkspaceService.reg` | Ink & Typing Personalization | *(registry only)* | Skip if you use a stylus or pen input |
| `Disable-Connected-User-Telemetry.reg` | WAP Push Message Routing Service | `dmwappushservice` | Feedback Hub app will stop working |
| `Disable-Data-Usage-Monitoring-Service.reg` | Data Usage Monitoring Service | `DusmSvc` | Windows Settings → Network → Data Usage will no longer update |
| `Disable-Windows-Error-Reporting-Control-Panel-Support.reg` | Windows Error Reporting Control Panel | *(registry only)* | The "Problem Reports" section in Control Panel will stop working |
| `Disable-WAPPushRouting.reg` | WAP Push Message Routing | `dmwappushservice` | — |
| `Disable-CompatTelRunner.reg` | Microsoft Compatibility Telemetry | *(task only)* | — |
| `Disable-Geolocation.reg` | Geolocation Service | `lfsvc` | Weather, Maps and Find My Device will stop working |
