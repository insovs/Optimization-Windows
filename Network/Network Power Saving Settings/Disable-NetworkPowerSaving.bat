@echo off
title Disable Network Power Saving [https://github.com/insovs]
setlocal EnableExtensions EnableDelayedExpansion

echo.
echo  This script disables power saving features on all network adapters.
echo  (Energy-Efficient Ethernet, Green Ethernet, Auto Disable Gigabit, etc.)
echo.
set /p confirm=" Apply ? [y/n]: "
if /i "%confirm%" neq "y" (echo. & echo  Aborted. & timeout /t 2 /nobreak >nul & exit /b)
echo.

:: ── Find all network adapter subkeys ──────────────────────────────────────────
set BASE=HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}

set count=0
for /f "tokens=*" %%A in ('reg query "%BASE%" /k 2^>nul ^| findstr /r "[0-9][0-9][0-9][0-9]"') do (
    set "subkey=%%A"

    :: Skip Properties subkey
    echo !subkey! | findstr /i "Properties" >nul
    if !errorlevel! neq 0 (
        set /a count+=1
        echo [!count!] Processing: %%A

        :: ── Energy-Efficient Ethernet ─────────────────────────────────────────
        reg add "!subkey!" /v "*EEE" /t REG_SZ /d "0" /f >nul 2>&1
        reg add "!subkey!" /v "EEELinkAdvertisement" /t REG_SZ /d "0" /f >nul 2>&1

        :: ── Green Ethernet ────────────────────────────────────────────────────
        reg add "!subkey!" /v "GreenEthernetEnabled" /t REG_SZ /d "0" /f >nul 2>&1
        reg add "!subkey!" /v "*GreenEthernet" /t REG_SZ /d "0" /f >nul 2>&1

        :: ── Auto Disable Gigabit ──────────────────────────────────────────────
        reg add "!subkey!" /v "AutoDisableGigabit" /t REG_SZ /d "0" /f >nul 2>&1

        :: ── Advanced EEE ──────────────────────────────────────────────────────
        reg add "!subkey!" /v "AdvancedEEE" /t REG_SZ /d "0" /f >nul 2>&1
        reg add "!subkey!" /v "*AdvancedEEE" /t REG_SZ /d "0" /f >nul 2>&1

        :: ── Flow Control ──────────────────────────────────────────────────────
        reg add "!subkey!" /v "*FlowControl" /t REG_SZ /d "0" /f >nul 2>&1

        :: ── Gigabit Lite ──────────────────────────────────────────────────────
        reg add "!subkey!" /v "GigaLite" /t REG_SZ /d "0" /f >nul 2>&1

        :: ── Power Management ──────────────────────────────────────────────────
        reg add "!subkey!" /v "PnPCapabilities" /t REG_DWORD /d 24 /f >nul 2>&1

        echo    + Done.
    )
)

:: ── PowerShell pass (covers display name variants across driver brands) ────────
echo.
echo  Disabling power management via PowerShell...
powershell -Command "Get-NetAdapter | ForEach-Object { $_ | Set-NetAdapterAdvancedProperty -DisplayName 'Energy-Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -Command "Get-NetAdapter | ForEach-Object { $_ | Set-NetAdapterAdvancedProperty -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -Command "Get-NetAdapter | ForEach-Object { $_ | Set-NetAdapterAdvancedProperty -DisplayName 'Green Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -Command "Get-NetAdapter | ForEach-Object { $_ | Set-NetAdapterAdvancedProperty -DisplayName 'Advanced EEE' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -Command "Get-NetAdapter | ForEach-Object { $_ | Set-NetAdapterAdvancedProperty -DisplayName 'EEE' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -Command "Get-NetAdapter | ForEach-Object { Disable-NetAdapterPowerManagement -Name $_.Name -ErrorAction SilentlyContinue }" >nul 2>&1
echo   + Done.

echo.
echo ================================================
echo  Network power saving disabled successfully.
echo  A restart is recommended to apply all changes.
echo ================================================
echo.

set /p restart=" Restart now? [y/n]: "
if /i "%restart%"=="y" (
    shutdown /r /t 5 /c "Reboot to apply network power saving changes."
) else (
    echo  Remember to restart your computer later.
)

pause
endlocal
exit /b
