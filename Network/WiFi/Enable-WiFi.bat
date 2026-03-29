@echo off
rem # WiFi Enable Script [https://github.com/insovs]
rem # Restores all WiFi-specific services, scheduled tasks and adapters to default.
title Enable WiFi [https://github.com/insovs]
setlocal EnableExtensions EnableDelayedExpansion

echo. & echo INFO: This will re-enable WiFi and all related services. & echo. & set /p confirm=" Enable WiFi ? [y/n]: "
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

:: ── Enable services ───────────────────────────────────────────────────────────
echo Enabling WiFi services...
for %%S in (%WIFI_SERVICES%) do (
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S" >nul 2>&1
    if !errorlevel! equ 0 (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
        if !errorlevel! equ 0 (
            echo   + %%S : enabled.
        ) else (
            echo   + %%S : error.
        )
    )
)

:: ── Scheduled tasks ───────────────────────────────────────────────────────────
echo.
echo Enabling WiFi scheduled tasks...
for %%T in (
    "\Microsoft\Windows\WCM\WiFiTask"
    "\Microsoft\Windows\WlanSvc\CDSSync"
    "\Microsoft\Windows\WlanSvc\MoProfileManagement"
    "\Microsoft\Windows\WwanSvc\NotificationTask"
    "\Microsoft\Windows\WwanSvc\OobeDiscovery"
) do (
    schtasks /change /enable /TN "%%T" >nul 2>&1
    if !errorlevel! equ 0 (
        echo   + %%T : enabled.
    ) else (
        echo   + %%T : not found or error.
    )
)

:: ── Enable PnP adapters ───────────────────────────────────────────────────────
echo.
echo Enabling WiFi adapters...
powershell -Command "Get-PnpDevice -Class Net | Where-Object { $_.FriendlyName -match 'Wi-Fi|Wireless|WLAN|802.11' -and $_.Status -ne 'OK' } | Enable-PnpDevice -Confirm:$false" >nul 2>&1
if !errorlevel! equ 0 (
    echo   + WiFi adapters : enabled.
) else (
    echo   + WiFi adapters : error or no adapters found.
)

:: ── Start services ────────────────────────────────────────────────────────────
echo.
echo Starting WiFi services...
sc start "WlanSvc" >nul 2>&1
sc start "Wcmsvc"  >nul 2>&1

:: ── Done ──────────────────────────────────────────────────────────────────────
echo.
echo ================================================
echo  WiFi enabled successfully.
echo  A restart may be required.
echo ================================================
echo.

set /p restart="Restart now? (Y/N): "
if /i "%restart%"=="Y" (
    shutdown /r /t 5 /c "Reboot to complete WiFi activation."
) else (
    echo Remember to restart your computer later.
)

pause
endlocal
exit /b
