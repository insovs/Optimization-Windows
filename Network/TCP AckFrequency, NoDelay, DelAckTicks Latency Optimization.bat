@echo off &setlocal enabledelayedexpansion
set "w=[97m" &set o=[7m& set q=[0m
title [guns.lol/inso.vs] TCP Low-Latency Optimization TcpAckFrequency=1, TCPNoDelay=1, TcpDelAckTicks=0
cls & echo. &echo  Applying TCP optimizations to reduce latency, lower ping, and improve network responsiveness: 
echo  in "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{YOUR GUID}\" &echo. & echo  TcpAckFrequency=1  : Immediate ACK transmission (disables delayed batching). &echo  TCPNoDelay=1       : Disables Nagle's algorithm. & echo  TcpDelAckTicks=0   : Sets ACK delay to minimum. &echo. &echo  For personal use only. Modifying, copying, or redistributing this script is prohibited. &echo  This script must be downloaded only from the official source: https://guns.lol/inso.vs. &echo. &echo ======================================================================================================================== &echo. &echo %o%Detected network adapters:%q% & echo. & set count=0
for /f "skip=1" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    echo %%a | find "{" >nul && (
        set /a count+=1 & set "adapter!count!=%%a"
        for %%x in ("%%a") do set "guid=%%~nx"
        set "adaptername=Unknown" & set "name!count!="
        for /f "tokens=2*" %%n in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\!guid!\Connection" /v Name 2^>nul ^| find "Name"') do (set "adaptername=%%o" & set "name!count!=%%o")
        set "ip=No IP"
        for /f "tokens=3" %%c in ('reg query "%%a" /v DhcpIPAddress 2^>nul ^| find "REG_SZ"') do if not "%%c"=="0.0.0.0" if not "%%c"=="" set "ip=%%c"
        if "!ip!"=="No IP" for /f "tokens=3 delims= " %%c in ('reg query "%%a" /v IPAddress 2^>nul ^| findstr /r "^[0-9]"') do if not "%%c"=="0.0.0.0" if not "%%c"=="" set "ip=%%c"
        echo [!count!] !adaptername! - !guid! - !ip!
    )
)

echo. &if %count%==0 (echo ERROR: No adapters found! & pause & exit) &echo %count% adapter(s) Found.
:ask_choice
set "choice="
set /p choice="Select adapter you want to configure (1-%count% or 0 for ALL): "
if not defined choice goto ask_choice
echo %choice%| findstr /r "^[0-9][0-9]*$" >nul || (echo Invalid input. Enter a number. & goto ask_choice)
if %choice% gtr %count% (echo Invalid choice. Must be 0-%count%. & goto ask_choice)
echo. &if "%choice%"=="0" (
    echo Applying to ALL adapters. &echo.
    for /L %%i in (1,1,%count%) do (
        reg add "!adapter%%i!" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
        reg add "!adapter%%i!" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
        reg add "!adapter%%i!" /v TcpDelAckTicks /t REG_DWORD /d 0 /f >nul 2>&1
        if !errorlevel! equ 0 (echo [OK] Adapter %%i configured.) else (echo [ERROR] Failed to configure adapter %%i.)
    )
    echo. &echo [SUCCESS] All adapters configured. &echo. &echo Restarting all network adapters. &echo.
    for /L %%i in (1,1,%count%) do (
        if defined name%%i (
            echo Restarting: !name%%i!
            netsh interface set interface "!name%%i!" disable >nul 2>&1
            if !errorlevel! equ 0 (timeout /t 2 /nobreak >nul) else (echo [WARNING] Could not disable !name%%i!)
            netsh interface set interface "!name%%i!" enable >nul 2>&1
            if !errorlevel! equ 0 (echo [OK] !name%%i! restarted.) else (echo [ERROR] Could not enable !name%%i!)
        )
    )
) else (
    echo Applying to adapter %choice%.
    reg add "!adapter%choice%!" /v TcpAckFrequency /t REG_DWORD /d 1 /f
    reg add "!adapter%choice%!" /v TCPNoDelay /t REG_DWORD /d 1 /f
    reg add "!adapter%choice%!" /v TcpDelAckTicks /t REG_DWORD /d 0 /f
    if !errorlevel! equ 0 (echo [SUCCESS] Adapter %choice% configured.) else (echo [ERROR] Failed to configure adapter.)
    if defined name%choice% (
        echo. &echo Restarting adapter: !name%choice%!...
        netsh interface set interface "!name%choice%!" disable >nul 2>&1
        if !errorlevel! equ 0 (timeout /t 2 /nobreak >nul) else (echo [WARNING] Could not disable adapter.)
        netsh interface set interface "!name%choice%!" enable >nul 2>&1
        if !errorlevel! equ 0 (timeout /t 3 /nobreak >nul & echo [OK] Adapter restarted successfully.) else (echo [ERROR] Could not enable adapter.)
    ) else (
        echo. &echo WARNING: Could not restart adapter automatically. &echo Please restart manually or reboot your PC.
    )
)

echo. &echo All Changes have been applied and adapter(s) restarted. &echo Choose an option : &echo. &echo [1] Quitter. &echo [2] Discord.
set /p "choice=" &if "%choice%"=="1" (timeout /t 1 /nobreak >nul & exit /b) else if "%choice%"=="2" (start https://guns.lol/inso.vs & pause >nul) else (pause >nul)