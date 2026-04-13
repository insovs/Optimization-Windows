# Telemetry & Diagnostics
> [!NOTE]
> Services that send data to Microsoft in the background. **Recommended to disable**.

| File | Service | Watch out |
|------|---------|-----------|
| `Disable-Connected-User-Experiences-and-Telemetry.reg` | Connected User Experiences and Telemetry (`DiagTrack`) | Feedback Hub app will stop working |
| `Disable-DiagnosticPolicy.reg` | Diagnostic Policy Service (`DPS`) | Windows built-in troubleshooters will stop working |
| `Disable-WindowsErrorReporting.reg` | Windows Error Reporting Service (`WerSvc`) | Crash dumps and error logs will no longer be sent — irrelevant for most users |
| `Disable-WindowsInsiderService.reg` | Windows Insider Service (`wisvc`) | Only needed if you are in the Insider Program |
| `Disable-Compatibility-Assistant-Service.reg` | Program Compatibility Assistant (`PcaSvc`) | Windows may stop warning you about incompatible apps |
| `Disable-DiagnosticHub.reg` | Microsoft Diagnostics Hub Standard Collector (`diagnosticshub.standardcollector.service`) | Skip if you use Visual Studio performance profiling |
| `Disable-OnlineSpeechRecognition.reg` | Online Speech Recognition (`SpeechRuntime`) | Cortana voice features will stop working |
| `Disable-Data-Usage-Monitoring-Service.reg` | Data Usage Monitoring Service (`DusmSvc`) | Windows Settings → Network → Data Usage will no longer update |
| `Disable-Windows-Error-Reporting-Control-Panel-Support.reg` | Windows Error Reporting Control Panel Support (`wercplsupport`) | The "Problem Reports" section in Control Panel will stop working |
| `Disable-WAPPushRouting.reg` | WAP Push Message Routing (`dmwappushservice`) | — |
| `Disable-Geolocation.reg` | Geolocation Service (`lfsvc`) | Weather, Maps and Find My Device will stop working |
| `Disable-MicrosoftEdgeServices.reg` | Microsoft Edge Elevation + Update Services (`MicrosoftEdgeElevationService`, `edgeupdate`, `edgeupdatem`) | Edge will no longer auto-update — irrelevant if you don't use Edge |
| `Disable-DistributedLinkTracking.reg` | Distributed Link Tracking Client (`TrkWks`) | Shortcuts to moved files may stop auto-resolving |
| `Disable-RetailDemo.reg` | Retail Demo Service (`RetailDemo`) | Microsoft demo service — pure retail telemetry |
| `Disable-InkWorkspaceService.reg` | Ink & Typing Personalization (`registry only`) | Skip if you use a stylus or pen input |
| `Disable-CompatTelRunner.reg` | Microsoft Compatibility Telemetry (`AppCompat policy`) | Random CPU spikes will stop — no user-facing impact |
