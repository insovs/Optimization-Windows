@echo off & title Enabling/Active MSI (Message Signaled Interrupts) Mode for Network Adapter. &set z=[7m& set i=[1m& set q=[0m & cls
echo. &echo %z% : Enabling/Active MSI (Message Signaled Interrupts) Mode for Network Adapter. %q% &echo.
echo  This script allows the Network Adapter to use MSI mode (Message Signaled Interrupts) with high priority.
echo  After executing this script, they will be displayed in MSI Util v3 tool with MSI mode enabled for these devices. &echo.
set /p choice="%z% : Do you want to proceed ? [Y/N]: %q%"
if /i "%choice%" neq "y" (
    echo Operation cancelled.
    timeout /t 3 /nobreak >nul 2>&1
    exit /b
)

set z=[7m& set i=[1m& set q=[0m & cls &echo.
echo  %z%Enabling/Active MSI (Message Signaled Interrupts) Mode for Network Adapter.. %q% & timeout /t 2 /nobreak >nul &echo.
echo try { > "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     $Host.UI.RawUI.WindowTitle = 'Enabling/Active MSI (Message Signaled Interrupts) Mode for Network Adapter.' >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     $adapters = Get-WmiObject Win32_NetworkAdapter ^| Where-Object { $_.PNPDeviceID -like 'PCI*' } ^| Select-Object -ExpandProperty PNPDeviceID >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     foreach ($dev in $adapters) { >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     Write-Host ' info:' -ForegroundColor Yellow -NoNewline >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     Write-Host ' Targeting device with PNPDeviceID: ' -NoNewline >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     Write-Host $dev -ForegroundColor DarkYellow >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     $insoptibaseKey = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + $dev + '\Device Parameters\Interrupt Management' >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     $insoptimsiPath = Join-Path $insoptibaseKey 'MessageSignaledInterruptProperties' >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     $insoptiaffinityPath = Join-Path $insoptibaseKey 'Affinity Policy' >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     if (-not (Test-Path $insoptimsiPath)) { New-Item -Path $insoptimsiPath -Force ^| Out-Null } >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     if (-not (Test-Path $insoptiaffinityPath)) { New-Item -Path $insoptiaffinityPath -Force ^| Out-Null } >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     Set-ItemProperty -Path $insoptimsiPath -Name 'MSISupported' -Type DWord -Value 1 -Force >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     Write-Host ' The operation completed successfully.' -ForegroundColor Green >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     Set-ItemProperty -Path $insoptiaffinityPath -Name 'DevicePriority' -Type DWord -Value 3 -Force >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     Write-Host ' The operation completed successfully.' -ForegroundColor Green >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1" & echo         Write-Host ' info:' -ForegroundColor Yellow -NoNewline >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1" & echo         Write-Host ' Completed adding values to the Registry.' >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1" & echo         Write-Host '' >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1" & echo         Write-Host ' Tweaks applied:' -ForegroundColor Green >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1" & echo         Write-Host ' - MSISupported = 1 (Enables Message Signaled Interrupts)' -ForegroundColor Gray >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1" & echo         Write-Host ' - DevicePriority = 3 (Sets high priority for network adapter interrupt handling)' -ForegroundColor Gray >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1" & echo         Write-Host '' >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo     } >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
echo } catch { Write-Error $_ } >> "%TEMP%\insoptiMSIForNetworkAdapter.ps1"

powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\insoptiMSIForNetworkAdapter.ps1"
del "%TEMP%\insoptiMSIForNetworkAdapter.ps1" >nul 2>&1

echo %z%Press any key for exit.%q%
pause >nul 2>&1
exit /b
