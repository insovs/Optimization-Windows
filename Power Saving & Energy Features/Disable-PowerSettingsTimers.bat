@echo off
setlocal enabledelayedexpansion
title Power Settings - CPU - Disk Idle Timers

echo Press any key to start the process.
pause >nul
cls
echo Applying power settings optimizations...

rem Disable system standby timer (0 = never)
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0

rem Disable automatic hibernation timer (0 = never)
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0

rem Disable Away mode
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP AWAYMODE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP AWAYMODE 0

rem Disable automatic screen turn-off (0 = never)
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0

rem Apply changes to the active power plan
powercfg /setactive SCHEME_CURRENT

echo.
echo Done.
echo.
echo Choose an option:
echo.
echo [1] Exit.
echo [2] Discord.
set /p "choice="
if "%choice%"=="1" (timeout /t 1 /nobreak >nul & exit /b) else if "%choice%"=="2" (start https://guns.lol/inso.vs & pause >nul) else (pause >nul)