@echo off & title Disable ETW / AutoLogger Traces

rem # Disables Windows ETW auto-loggers to reduce background logging and improve performance.
rem # WARNING: Disabling system logging impact diagnostics and monitoring.
rem # Use only if you know what you're doing or if you prioritize maximum performance and lowest latency above all.

:: Auto-elevate to admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Relaunch as TrustedInstaller via PowerRun
whoami /groups | find /i "S-1-5-80-956008885" >nul 2>&1
if %errorlevel% neq 0 (
    echo Relaunching as TrustedInstaller via PowerRun...
    "%~dp0PowerRun.exe" "%~f0"
    exit /b
)

:: User confirmation
echo. & echo This will disable ALL Windows ETW auto-loggers, which are optional background logging services,
echo to reduce overhead and improve performance (may affect diagnostics). & echo.
set /p confirm="Proceed with disabling ETW auto-loggers? [y/n]: "
if /i "%confirm%" neq "y" (
    echo.
    echo Aborted.
    timeout /t 2 /nobreak > nul
    exit /b
)
echo. & echo [*] Starting ETW auto-logger disable sequence. & echo.

:: Disable auto-loggers
set R=HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger
reg add "%R%\AppModel" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] AppModel || echo [ERROR] AppModel
reg add "%R%\AutoLogger-Diagtrack-Listener" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] AutoLogger-Diagtrack-Listener || echo [ERROR] AutoLogger-Diagtrack-Listener
reg add "%R%\Cellcore" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Cellcore || echo [ERROR] Cellcore
reg add "%R%\Circular Kernel Context Logger" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Circular Kernel Context Logger || echo [ERROR] Circular Kernel Context Logger
reg add "%R%\CloudExperienceHostOobe" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] CloudExperienceHostOobe || echo [ERROR] CloudExperienceHostOobe
reg add "%R%\DataMarket" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] DataMarket || echo [ERROR] DataMarket
reg add "%R%\DefenderApiLogger" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] DefenderApiLogger || echo [ERROR] DefenderApiLogger
reg add "%R%\DefenderAuditLogger" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] DefenderAuditLogger || echo [ERROR] DefenderAuditLogger
reg add "%R%\Diagtrack-Listener" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Diagtrack-Listener || echo [ERROR] Diagtrack-Listener
reg add "%R%\EventLog-Application" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] EventLog-Application || echo [ERROR] EventLog-Application
reg add "%R%\EventLog-Security" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] EventLog-Security || echo [ERROR] EventLog-Security
reg add "%R%\EventLog-System" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] EventLog-System || echo [ERROR] EventLog-System
reg add "%R%\HolographicDevice" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] HolographicDevice || echo [ERROR] HolographicDevice
reg add "%R%\LwtNetLog" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] LwtNetLog || echo [ERROR] LwtNetLog
reg add "%R%\Mellanox-Kernel" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Mellanox-Kernel || echo [ERROR] Mellanox-Kernel
reg add "%R%\Microsoft-Windows-AssignedAccess" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Microsoft-Windows-AssignedAccess || echo [ERROR] Microsoft-Windows-AssignedAccess
reg add "%R%\Microsoft-Windows-Rdp-Graph" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Microsoft-Windows-Rdp-Graph || echo [ERROR] Microsoft-Windows-Rdp-Graph
reg add "%R%\Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace || echo [ERROR] Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace
reg add "%R%\Microsoft-Windows-Setup" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Microsoft-Windows-Setup || echo [ERROR] Microsoft-Windows-Setup
reg add "%R%\NBSMBLOGGER" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] NBSMBLOGGER || echo [ERROR] NBSMBLOGGER
reg add "%R%\NetCore" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] NetCore || echo [ERROR] NetCore
reg add "%R%\NtfsLog" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] NtfsLog || echo [ERROR] NtfsLog
reg add "%R%\PEAuthLog" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] PEAuthLog || echo [ERROR] PEAuthLog
reg add "%R%\RadioMgr" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] RadioMgr || echo [ERROR] RadioMgr
reg add "%R%\RdrLog" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] RdrLog || echo [ERROR] RdrLog
reg add "%R%\ReadyBoot" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] ReadyBoot || echo [ERROR] ReadyBoot
reg add "%R%\SetupPlatform" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] SetupPlatform || echo [ERROR] SetupPlatform
reg add "%R%\SetupPlatformTel" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] SetupPlatformTel || echo [ERROR] SetupPlatformTel
reg add "%R%\SpoolerLogger" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] SpoolerLogger || echo [ERROR] SpoolerLogger
reg add "%R%\SQMLogger" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] SQMLogger || echo [ERROR] SQMLogger
reg add "%R%\TCPIPLOGGER" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] TCPIPLOGGER || echo [ERROR] TCPIPLOGGER
reg add "%R%\TileStore" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] TileStore || echo [ERROR] TileStore
reg add "%R%\Tpm" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] Tpm || echo [ERROR] Tpm
reg add "%R%\UBPM" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] UBPM || echo [ERROR] UBPM
reg add "%R%\WdiContextLog" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] WdiContextLog || echo [ERROR] WdiContextLog
reg add "%R%\WFP-IPsec Trace" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] WFP-IPsec Trace || echo [ERROR] WFP-IPsec Trace
reg add "%R%\WiFiDriverHVSession" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] WiFiDriverHVSession || echo [ERROR] WiFiDriverHVSession
reg add "%R%\WiFiDriverHVSessionRepro" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] WiFiDriverHVSessionRepro || echo [ERROR] WiFiDriverHVSessionRepro
reg add "%R%\WiFiSession" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] WiFiSession || echo [ERROR] WiFiSession
reg add "%R%\WinPhoneCritical" /v Start /t REG_DWORD /d 0 /f >nul 2>&1 && echo [OK] WinPhoneCritical || echo [ERROR] WinPhoneCritical


echo.
echo [OK] Done. A restart is required to apply the changes.
echo.
pause
exit
