@echo off
rem # Bluetooth Enable Script [https://github.com/insovs]
rem # Restores all Bluetooth-specific services, adapters, drivers, radio and policies to default.
title Enable Bluetooth [https://github.com/insovs]
setlocal EnableExtensions EnableDelayedExpansion

echo. & echo INFO: This will re-enable Bluetooth and all related services. & echo. & set /p confirm=" Enable Bluetooth ? [y/n]: "
if /i "%confirm%" neq "y" (echo. & echo  Aborted. & timeout /t 2 /nobreak >nul & exit /b)
echo. & echo  [*] Starting. & echo.

:: ── Services list ─────────────────────────────────────────────────────────────
set BLUETOOTH_SERVICES=^
    bthserv ^
    BthEnum ^
    BthA2dp ^
    BthHFEnum ^
    BthLEEnum ^
    BTHPORT ^
    BTHUSB ^
    RFCOMM ^
    BTAGService ^
    BthAvctpSvc ^
    HidBth ^
    BthPan ^
    BTHMODEM ^
    BthMini ^
    BthAvrcpTg ^
    Microsoft_Bluetooth_AvrcpTransport ^
    BluetoothUserService ^
    RtkBtManServ

:: ── Enable services ───────────────────────────────────────────────────────────
echo Enabling Bluetooth services...
for %%S in (%BLUETOOTH_SERVICES%) do (
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

:: ── Policy ────────────────────────────────────────────────────────────────────
echo.
echo Restoring Bluetooth policy...
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Connectivity\AllowBluetooth" /v value /t REG_DWORD /d 2 /f >nul 2>&1
if !errorlevel! equ 0 (
    echo   + Bluetooth policy : enabled.
) else (
    echo   + Bluetooth policy : error.
)

:: ── Enable PnP adapters ───────────────────────────────────────────────────────
echo.
echo Enabling Bluetooth adapters...
powershell -Command "Get-PnpDevice -Class Bluetooth | Where-Object { $_.Status -ne 'OK' } | Enable-PnpDevice -Confirm:$false" >nul 2>&1
if !errorlevel! equ 0 (
    echo   + Bluetooth adapters : enabled.
) else (
    echo   + Bluetooth adapters : error or no adapters found.
)

:: ── Enable radio ──────────────────────────────────────────────────────────────
echo.
echo Enabling Bluetooth radio...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{e0cbf06c-cd8b-4647-bb8a-263b43f0f974}" /v DisableBluetooth /t REG_DWORD /d 0 /f >nul 2>&1
if !errorlevel! equ 0 (
    echo   + Bluetooth radio : enabled.
) else (
    echo   + Bluetooth radio : error.
)

:: ── Start services ────────────────────────────────────────────────────────────
echo.
echo Starting Bluetooth services...
sc start "bthserv"              >nul 2>&1
sc start "BluetoothUserService" >nul 2>&1

:: ── Done ──────────────────────────────────────────────────────────────────────
echo.
echo ================================================
echo  Bluetooth enabled successfully.
echo  A restart may be required.
echo ================================================
echo.

set /p restart="Restart now? (Y/N): "
if /i "%restart%"=="Y" (
    shutdown /r /t 5 /c "Reboot to complete Bluetooth activation."
) else (
    echo Remember to restart your computer later.
)

pause
endlocal
exit /b
