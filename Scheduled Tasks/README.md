# Windows Scheduled Tasks Disable Script

This script disables a large set of Windows Scheduled Tasks known to impact **performance**, **privacy**, and **system latency**.
It is optimized for **gaming**, **low-latency systems**, and general **debloating** without affecting critical OS functionality.

The script targets:

* Telemetry & CEIP
* Diagnostics & troubleshooting tasks
* Background maintenance
* .NET NGEN (CPU spikes)
* Cloud sync & settings sync
* Maps, Feedback, Cortana, Error Reporting
* Windows Update auxiliary tasks
* Google Update tasks
* Office Telemetry
* Family Safety

The script automatically elevates to Administrator.

## How to Use

1. Download `Disable Scheduled Tasks.bat`.
2. Run it with PowerRun.exe (auto-elevation will request admin privileges).

## Note

No core system or security-critical tasks are disabled.
All changes are reversible via Task Scheduler.

---

# 📋 Task List & Default Purpose

Below is a table explaining **each disabled task** and its **default function** in Windows.

| Task Name                                  | Default Purpose                                                       |
| ------------------------------------------ | --------------------------------------------------------------------- |
| AppID PolicyConverter                      | Converts application policy data for AppID.                           |
| VerifiedPublisherCertStoreCheck            | Validates certificates for application publishers.                    |
| Microsoft Compatibility Appraiser          | Collects app/driver telemetry for Windows Update compatibility.       |
| ProgramDataUpdater                         | Updates compatibility program database.                               |
| StartupAppTask                             | Analyzes startup apps for performance diagnostics.                    |
| MareBackup                                 | Compatibility telemetry backup.                                       |
| PcaPatchDbTask                             | Program Compatibility Assistant patch updates.                        |
| AppData Verifier Daily                     | App data integrity verification.                                      |
| AppData Verifier Fire Install              | Verifies apps upon installation.                                      |
| CleanupTemporaryState                      | Cleans temporary application states.                                  |
| DsSvcCleanup                               | Data store cleanup for ApplicationData services.                      |
| Autochk Proxy                              | Disk check processing support task.                                   |
| CEIP Consolidator                          | Collects Customer Experience Improvement telemetry.                   |
| KernelCeipTask                             | Sends kernel-level telemetry.                                         |
| UsbCeip                                    | Collects USB device usage data.                                       |
| DiskDiagnostic DataCollector               | Collects disk health & failure prediction telemetry.                  |
| DiskFootprint Diagnostics                  | Analyzes disk usage for storage suggestions.                          |
| Power Efficiency Diagnostics AnalyzeSystem | Runs power efficiency analysis.                                       |
| StorageSense                               | Automatic cleanup of temporary files.                                 |
| WinINet CacheTask                          | Maintains internet cache for WinINet API.                             |
| WinSAT                                     | Windows performance assessment benchmark (runs after updates).        |
| MapsToastTask                              | Pushes notifications for offline maps updates.                        |
| MapsUpdateTask                             | Downloads and updates offline maps.                                   |
| .NET NGEN v4 (x86/x64)                     | Background JIT compilation to optimize .NET apps (causes CPU spikes). |
| BackgroundConfigSurveyor                   | Collects performance config telemetry.                                |
| Search Gather Wired/Wireless               | Indexing telemetry for Windows Search diagnostics.                    |
| Offline Files Background Sync              | Syncs offline files with network shares.                              |
| Offline Files Logon Sync                   | Syncs offline files at logon.                                         |
| ForceSynchronizeTime                       | Forces time sync task.                                                |
| SynchronizeTime                            | Periodic system time synchronization.                                 |
| SettingSync BackgroundUploadTask           | Uploads user settings to Microsoft cloud.                             |
| SettingSync NetworkStateChangeTask         | Syncs settings when network changes.                                  |
| FamilySafetyMonitor                        | Parental control monitoring task.                                     |
| FamilySafetyRefresh                        | Updates family safety data.                                           |
| FamilySafetyUpload                         | Uploads family safety activity data to Microsoft.                     |
| SpeechModelDownloadTask                    | Downloads new speech recognition models.                              |
| SystemSoundsService                        | Manages default system sounds events.                                 |
| WER QueueReporting                         | Sends Windows Error Reporting crash data.                             |
| SIUF DmClient                              | Feedback/telemetry upload task.                                       |
| SIUF ScenarioDownload                      | Downloads telemetry scenarios for feedback.                           |
| PushToInstall LoginCheck                   | Preloads installation push notifications.                             |
| PushToInstall Registration                 | Registers system for push installation events.                        |
| OfficeTelemetryAgentFallBack               | Office usage telemetry.                                               |
| OfficeTelemetryAgentLogOn                  | Sends Office telemetry on logon.                                      |
| Office 15 Subscription Heartbeat           | Periodically validates Office 365 subscription status.                |
| CloudExperienceHost CreateObjectTask       | Creates CEH objects for OOBE/UX.                                      |
| CloudExperienceHost CreateUserTask         | Manages Cloud Experience Host user creation flow.                     |
| UpdateOrchestrator Schedule Scan           | Schedules Windows Update scans.                                       |
| UpdateOrchestrator UpdateModelTask         | Update model/logic maintenance.                                       |
| Automatic App Update                       | Updates Microsoft Store apps.                                         |
| SIH / SIHBoot                              | Repairs Windows Update components daily.                              |
| Input MouseSyncDataAvailable               | Syncs mouse input data to cloud (cross-device).                       |
| Input PenSyncDataAvailable                 | Syncs pen input data to cloud.                                        |
| Input TouchpadSyncDataAvailable            | Syncs touchpad input data to cloud.                                   |
| InstallService ScanForUpdates              | Internal update scanning task.                                        |
| SmartRetry                                 | Retry logic for updates after failure.                                |
| WakeUpAndContinueUpdates                   | Wakes system for updates.                                             |
| WakeUpAndScanForUpdates                    | Wakes system to scan for updates.                                     |
| GoogleUpdateTaskMachineCore                | Google update background runner.                                      |
| GoogleUpdateTaskMachineUA                  | Google update automatic updater.                                      |
| Data Integrity Scan                        | Performs data integrity scans.                                        |
| Data Integrity Scan for Crash Recovery     | Integrity scan after system crash.                                    |
| CriticalDataRecovery                       | Data recovery scan for critical files.                                |
| RecommendedTroubleshootingScanner          | Automatic recommended troubleshooting.                                |
| Diagnosis Scheduled                        | Regular diagnostic scans.                                             |

---
