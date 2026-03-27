@echo off & setlocal enabledelayedexpansion & title [guns.lol/inso.vs] Disable Power Throttling + CoalescingTimerInterval Optimization. &
echo press any key for start the process. &pause >nul &cls
echo Disabling Power Throttling and set CoalescingTimerInterval.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f & timeout /t 1 /nobreak >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "TimerCoalescing" /t REG_BINARY /d 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 /f
for %%p in ("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" 
"HKLM\SYSTEM\CurrentControlSet\Control" 
"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" 
"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" 
"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" 
"HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" 
"HKLM\SYSTEM\CurrentControlSet\Control\Power") do reg add "%%~p" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
for %%v in ("PlatformAoAcOverride" "EnergyEstimationEnabled" "EventProcessorEnabled" "CsEnabled") do reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "%%~v" /t REG_DWORD /d "0" /f
for %%v in ("ScreenSaveActive" "ScreenSaveTimeOut") do reg add "HKCU\Control Panel\Desktop" /v "%%~v" /t REG_SZ /d "0" /f & reg add "HKCU\Control Panel\Desktop" /v "SCRNSAVE.EXE" /t REG_SZ /d "" /f
echo Choose an option : &echo. &echo [1] Quitter. &echo [2] Discord.
set /p "choice=" &if "%choice%"=="1" (timeout /t 1 /nobreak >nul & exit /b) else if "%choice%"=="2" (start https://guns.lol/inso.vs & pause >nul) else (pause >nul)