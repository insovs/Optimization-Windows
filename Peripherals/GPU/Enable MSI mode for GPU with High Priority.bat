@echo off & title Active MSI (Message Signaled Interrupts) Mode for GPU/GPU's.
set z=[7m& set i=[1m& set q=[0m & cls
echo. &echo  This allows the GPU to use MSI mode (Message Signaled Interrupts). After executing this,
echo  they will be displayed in MSI Util v3 tool with MSI mode actived and enabled for these devices. &echo.
set /p choice="%z% : Do you want to proceed ? [Y/N]: %q%"
if /i "%choice%" neq "y" (
    echo Operation cancelled.
    timeout /t 3 /nobreak >nul 2>&1
    exit /b
)

REM Enable MSI Mode for GPU/GPU's.
echo %z% : Enable MSI (Message Signaled Interrupts) Mode..%q% &echo. &timeout /t 1 /nobreak >nul 2>&1
for /f "tokens=*" %%g in ('wmic path win32_videocontroller get PNPDeviceID 2^>nul ^| find "VEN_" ^| find /v "PNPDeviceID"') do (
    echo  Processing GPU: %%g &reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
    REM Priority device set to "High" (not added by default).
    REM reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "3" /f
)
if errorlevel 1 for /f "tokens=*" %%g in ('powershell -NoP -C "Get-PnpDevice -Class Display | Where-Object { $_.InstanceId -match "VEN_" } | %{ $_.InstanceId }"') do (
    echo  Processing GPU: %%g &reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
    REM Priority device set to "High" (not added by default).
    REM reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "3" /f
)

timeout /t 1 /nobreak >nul 2>&1
echo. &echo %z% : Press any key for exit.%q%
pause >nul 2>&1
exit /b
