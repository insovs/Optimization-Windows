@echo off
rem # Bluetooth Disable Script [https://github.com/insovs]
rem # Disables all Bluetooth-specific services, adapters, drivers, radio and policies.
rem # Safe to apply if you have no Bluetooth peripherals connected.
title Disable Bluetooth [https://github.com/insovs]
setlocal EnableExtensions EnableDelayedExpansion

echo. & echo INFO: This will disable Bluetooth and all related services. & echo. & set /p confirm=" Disable Bluetooth ? [y/n]: "
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

:: ── Stop services ─────────────────────────────────────────────────────────────
echo Stopping Bluetooth services...
sc stop "bthserv"              >nul 2>&1
sc stop "BluetoothUserService" >nul 2>&1
timeout /t 2 /nobreak >nul

:: ── Disable services ──────────────────────────────────────────────────────────
echo Disabling Bluetooth services...
for %%S in (%BLUETOOTH_SERVICES%) do (
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

:: ── Policy ────────────────────────────────────────────────────────────────────
echo.
echo Applying Bluetooth policy...
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Connectivity\AllowBluetooth" /v value /t REG_DWORD /d 0 /f >nul 2>&1
if !errorlevel! equ 0 (
    echo   + Bluetooth policy : disabled.
) else (
    echo   + Bluetooth policy : error.
)

:: ── Disable PnP adapters ──────────────────────────────────────────────────────
echo.
echo Disabling Bluetooth adapters...
powershell -Command "Get-PnpDevice -Class Bluetooth | Where-Object { $_.Status -eq 'OK' } | Disable-PnpDevice -Confirm:$false" >nul 2>&1
if !errorlevel! equ 0 (
    echo   + Bluetooth adapters : disabled.
) else (
    echo   + Bluetooth adapters : error or no adapters found.
)

:: ── Disable radio ─────────────────────────────────────────────────────────────
echo.
echo Disabling Bluetooth radio...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{e0cbf06c-cd8b-4647-bb8a-263b43f0f974}" /v DisableBluetooth /t REG_DWORD /d 1 /f >nul 2>&1
if !errorlevel! equ 0 (
    echo   + Bluetooth radio : disabled.
) else (
    echo   + Bluetooth radio : error.
)

:: ── Done ──────────────────────────────────────────────────────────────────────
echo.
echo ================================================
echo  Bluetooth disabled successfully.
echo ================================================
echo.

set /p restart="Restart now? (Y/N): "
if /i "%restart%"=="Y" (
    shutdown /r /t 5 /c "Reboot to complete Bluetooth deactivation."
) else (
    echo Remember to restart your computer later.
)

pause
endlocal
exit /b
