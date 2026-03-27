@echo off & cls

rem Enables MSI (Message Signaled Interrupts) mode and sets High Priority
rem for all detected USB controllers via WMIC with PowerShell fallback.

title Enable MSI Mode + High Priority for USB Controllers [https://github.com/insovs]
echo. & echo This script enables MSI (Message Signaled Interrupts) mode and sets High Priority for USB controllers. & echo.
set /p choice=Proceed? [Y/N]: 
if /i not "%choice%"=="y" (
    echo Operation cancelled.
    timeout /t 2 /nobreak >nul
    exit /b
)

echo. & echo Enabling MSI mode and setting High Priority. & echo.

:: ─── Try WMIC first ───────────────────────────────────────────────────────────────────────────────────────────────
set wmic_failed=0
for /f "skip=1 delims=" %%i in ('wmic path Win32_USBController get PNPDeviceID 2^>nul') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    if defined line (
        set "line=!line: =!"
        echo Processing: !line!
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\!line!\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v MSISupported /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\!line!\Device Parameters\Interrupt Management\Affinity Policy" /v DevicePriority /t REG_DWORD /d 3 /f
    ) else set wmic_failed=1
    endlocal
)

:: ─── PowerShell fallback ──────────────────────────────────────────────────────────────────────────────────────────
if %wmic_failed%==1 (
    echo.
    echo WMIC failed, using PowerShell.
    for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-PnpDevice -Class USB ^| Where-Object { $_.InstanceId -match ''VEN_'' } ^| ForEach-Object { $_.InstanceId }"') do (
        echo Processing: %%i
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v MSISupported /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v DevicePriority /t REG_DWORD /d 3 /f
    )
)

:: ─── End ──────────────────────────────────────────────────────────────────────────────────────────────────────────
echo. & echo MSI mode + High Priority set for detected USB controllers.
pause
exit /b
