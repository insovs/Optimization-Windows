@echo off
setlocal enabledelayedexpansion
title CoalescingTimerInterval Optimization
echo press any key to start the process.
pause >nul
cls
echo Setting TimerCoalescing and CoalescingTimerInterval.

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "TimerCoalescing" /t REG_BINARY /d 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 /f

for %%p in (
    "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager"
    "HKLM\SYSTEM\CurrentControlSet\Control"
    "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
    "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
    "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive"
    "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep"
    "HKLM\SYSTEM\CurrentControlSet\Control\Power"
) do reg add "%%~p" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f

echo.
echo Done.
echo.
echo Choose an option :
echo.
echo [1] Quitter.
echo [2] Discord.
set /p "choice="
if "%choice%"=="1" (timeout /t 1 /nobreak >nul & exit /b) else if "%choice%"=="2" (start https://guns.lol/inso.vs & pause >nul) else (pause >nul)
