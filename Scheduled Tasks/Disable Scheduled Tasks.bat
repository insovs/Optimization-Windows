@echo off
rem # Scheduled Tasks Disable Script [https://github.com/insovs]
rem # Disables unnecessary Windows scheduled tasks for performance and privacy optimization (gaming / general use).
rem # Targets telemetry, CEIP, feedback, diagnostics, cloud sync, .NET NGEN spikes, and other background noise.
rem # No critical system functionality is affected. Run as Administrator.

:: ── Auto-elevation ───────────────────────────────────────────────────────────
if "%1"=="elevated" goto :main
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%~dp0%~nx0' -ArgumentList 'elevated' -Verb RunAs"
    exit /b
)

:main
:: ── AppID ────────────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\AppID\PolicyConverter"                                    /Disable
schtasks /Change /TN "\Microsoft\Windows\AppID\VerifiedPublisherCertStoreCheck"                    /Disable

:: ── Application Experience ───────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"                /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask"                    /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\MareBackup"                        /Disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask"                    /Disable

:: ── Application Data ─────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\appuriverifierdaily"                      /Disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\appuriverifierfireinstall"                /Disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\CleanupTemporaryState"                    /Disable
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup"                             /Disable

:: ── Autochk ──────────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy"                                            /Disable

:: ── CEIP ─────────────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"     /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"   /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"          /Disable

:: ── Diagnostics ──────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
schtasks /Change /TN "\Microsoft\Windows\DiskFootprint\Diagnostics"                                /Disable
schtasks /Change /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"               /Disable

:: ── Disk / Storage ───────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\DiskFootprint\StorageSense"                               /Disable

:: ── Internet Cache ───────────────────────────────────────────────────────────
schtasks /Change /TN "Microsoft\Windows\Wininet\CacheTask"                                         /Disable

:: ── Maintenance ──────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT"                                       /Disable

:: ── Maps ─────────────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask"                                       /Disable
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask"                                      /Disable

:: ── .NET NGEN (background JIT recompilation — CPU spikes) ───────────────────
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"            /Disable
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"         /Disable

:: ── Performance Track ────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\PerfTrack\BackgroundConfigSurveyor"                       /Disable

:: ── Search ───────────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Search\GatherWired"                                       /Disable
schtasks /Change /TN "\Microsoft\Windows\Search\GatherWiredLog"                                    /Disable
schtasks /Change /TN "\Microsoft\Windows\Search\GatherWireless"                                    /Disable
schtasks /Change /TN "\Microsoft\Windows\Search\GatherWirelessLog"                                 /Disable

:: ── Offline Files ────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Offline Files\Background Synchronization"                 /Disable
schtasks /Change /TN "\Microsoft\Windows\Offline Files\Logon Synchronization"                      /Disable

:: ── Time Synchronization ─────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"                /Disable
schtasks /Change /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime"                     /Disable

:: ── Settings Sync (cloud) ────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\SettingSync\BackgroundUploadTask"                         /Disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\NetworkStateChangeTask"                       /Disable

:: ── Shell / Family Safety ────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor"                                /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefresh"                                /Disable
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyUpload"                                 /Disable

:: ── Speech / Cortana ─────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Speech\SpeechModelDownloadTask"                           /Disable

:: ── System Sounds ────────────────────────────────────────────────────────────
schtasks /Change /TN "Microsoft\Windows\SystemSoundsService"                                       /Disable

:: ── Windows Error Reporting ──────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting"                   /Disable

:: ── Feedback / SIUF ──────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClient"                                  /Disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"                /Disable

:: ── Push To Install ──────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\LoginCheck"                                 /Disable
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\Registration"                               /Disable

:: ── Office Telemetry ─────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack"                              /Disable
schtasks /Change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn"                                 /Disable
schtasks /Change /TN "\Microsoft\Office\Office 15 Subscription Heartbeat"                          /Disable

:: ── Cloud Experience Host ────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"                     /Disable
schtasks /Change /TN "\Microsoft\Windows\CloudExperienceHost\CreateUserTask"                       /Disable

:: ── Update Orchestrator ──────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"                         /Disable
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask"                       /Disable

:: ── Windows Update ───────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update"                       /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih"                                        /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot"                                    /Disable

:: ── Input Sync (cloud store handlers) ───────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Input\MouseSyncDataAvailable"                             /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\PenSyncDataAvailable"                               /Disable
schtasks /Change /TN "\Microsoft\Windows\Input\TouchpadSyncDataAvailable"                          /Disable

:: ── Install Service ──────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\InstallService\ScanForUpdates"                            /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"                      /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\SmartRetry"                                /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\WakeUpAndContinueUpdates"                  /Disable
schtasks /Change /TN "\Microsoft\Windows\InstallService\WakeUpAndScanForUpdates"                   /Disable

:: ── Google Update ────────────────────────────────────────────────────────────
schtasks /Change /TN "\GoogleUpdateTaskMachineCore"                                                /Disable
schtasks /Change /TN "\GoogleUpdateTaskMachineUA"                                                  /Disable

:: ── Data Integrity Scan ──────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"                  /Disable
schtasks /Change /TN "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery" /Disable
schtasks /Change /TN "\Microsoft\Windows\Data Integrity Scan\Microsoft-Windows-DataIntegrityScan-CriticalDataRecovery" /Disable

:: ── Diagnosis ────────────────────────────────────────────────────────────────
schtasks /Change /TN "\Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner"              /Disable
schtasks /Change /TN "\Microsoft\Windows\Diagnosis\Scheduled"                                      /Disable

echo.
echo [DONE] All tasks processed.
pause
