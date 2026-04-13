@echo off
rem # WiFi Disable Script [https://github.com/insovs]
rem # Disables all WiFi-specific services, scheduled tasks and adapters.
rem # Safe to apply only if you use a wired (Ethernet) connection.
title Disable WiFi [https://github.com/insovs]
setlocal EnableExtensions EnableDelayedExpansion

echo. & echo INFO: This will disable WiFi and all related services. & echo. & set /p confirm=" Disable WiFi ? [y/n]: "
if /i "%confirm%" neq "y" (echo. & echo  Aborted. & timeout /t 2 /nobreak >nul & exit /b)
echo. & echo  [*] Starting. & echo.

:: ── Admin check ───────────────────────────────────────────────────────────────
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    echo Right-click and select "Run as administrator".
    pause & exit /b 1
)

:: ── Services list ─────────────────────────────────────────────────────────────
set WIFI_SERVICES=^
    WlanSvc ^
    vwififlt ^
    Wcmsvc

:: ── Stop services ─────────────────────────────────────────────────────────────
echo Stopping WiFi services...
sc stop "WlanSvc" >nul 2>&1
sc stop "Wcmsvc"  >nul 2>&1
timeout /t 2 /nobreak >nul

:: ── Disable services ──────────────────────────────────────────────────────────
echo Disabling WiFi services...
for %%S in (%WIFI_SERVICES%) do (
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S" >nul 2>&1
    if !errorlevel! equ 0 (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
        if !errorlevel! equ 0 (
            echo   + %%S : disabled.
        ) else (
            echo   + %%S : error.
        )
    )
)

:: ── Scheduled tasks ───────────────────────────────────────────────────────────
echo.
echo Disabling WiFi scheduled tasks...
for %%T in (
    "\Microsoft\Windows\WCM\WiFiTask"
    "\Microsoft\Windows\WlanSvc\CDSSync"
    "\Microsoft\Windows\WlanSvc\MoProfileManagement"
    "\Microsoft\Windows\WwanSvc\NotificationTask"
    "\Microsoft\Windows\WwanSvc\OobeDiscovery"
) do (
    schtasks /change /disable /TN "%%T" >nul 2>&1
    if !errorlevel! equ 0 (
        echo   + %%T : disabled.
    ) else (
        echo   + %%T : not found or error.
    )
)

:: ── Disable PnP adapters ──────────────────────────────────────────────────────
echo.
echo Disabling WiFi adapters...
powershell -Command "Get-PnpDevice -Class Net | Where-Object { $_.FriendlyName -match 'Wi-Fi|Wireless|WLAN|802.11' -and $_.Status -eq 'OK' } | Disable-PnpDevice -Confirm:$false" >nul 2>&1
if !errorlevel! equ 0 (
    echo   + WiFi adapters : disabled.
) else (
    echo   + WiFi adapters : error or no adapters found.
)

:: ── Done ──────────────────────────────────────────────────────────────────────
echo.
echo ================================================
echo  WiFi disabled successfully.
echo ================================================
echo.

set /p restart="Restart now? (Y/N): "
if /i "%restart%"=="Y" (
    shutdown /r /t 5 /c "Reboot to complete WiFi deactivation."
) else (
    echo Remember to restart your computer later.
)

pause
endlocal
exit /b
