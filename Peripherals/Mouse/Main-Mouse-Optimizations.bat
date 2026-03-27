@echo off
title Mouse Registry Tweaks by [https://guns.lol/inso.vs]

echo. & echo INFO: This script will apply recommended mouse settings for low-latency and precise movement.
echo Press any key to continue.
pause
cls

:: Mouse sensitivity / acceleration
echo [*] Setting mouse sensitivity and disabling acceleration...
reg add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d 10 /f
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseAccel /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v DoubleClickSpeed /t REG_SZ /d 200 /f
reg add "HKCU\Control Panel\Mouse" /v SwapMouseButtons /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v SnapToDefaultButton /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v ActiveWindowTracking /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v Beep /t REG_SZ /d "No" /f
reg add "HKCU\Control Panel\Mouse" /v ExtendedSounds /t REG_SZ /d "No" /f

:: Mouse hover / trails
echo [*] Adjusting hover time and cursor trails...
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseTrails /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseDelay /t REG_SZ /d 0 /f

:: Linear mouse curve (no acceleration)
echo [*] Forcing linear X/Y curves...
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_SZ /d "000000000000000000000000000000000000000000000000" /f
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_SZ /d "000000000000000000000000000000000000000000000000" /f

:: PS/2 mouse polling
echo [*] Reducing PS/2 polling iterations for minimal latency...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v PollStatusIterations /t REG_DWORD /d 1 /f

:: Restart Explorer to apply settings
echo. & echo [*] Restarting Explorer to apply settings...
taskkill /f /im explorer.exe >nul
start explorer.exe >nul

:: End / Options
echo. & echo Choose an option:
echo [1] Quit
echo [2] Open Discord / Info Page

set /p "choice=Enter your choice: "
if "%choice%"=="1" (
    exit /b
) else if "%choice%"=="2" (
    start https://guns.lol/inso.vs
    pause >nul
) else (
    pause >nul
)
