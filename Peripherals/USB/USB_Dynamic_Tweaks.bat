@echo off & title USB Dynamic Tweaks

rem USB_Dynamic_Tweaks.bat
rem Enumerates all active USB and HID devices and strips every power saving,
rem idle and wake setting found — dramatically reducing input latency.
rem Requires administrator rights and a reboot.

:: Auto-elevate to admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo. & echo [*] USB Dynamic Tweaks - Starting. & echo.

:: ── Per-device scan of all USB + HID PnP devices via Enum\USB registry tree. Covers any device not caught by the targeted loops below. ─────────────────────────────────────────────────────
echo [*] Scanning all USB + HID PnP devices (Enum\USB). 
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "Device Parameters" 2^>nul ^| findstr /i "Device Parameters"') do (
  reg add "%%i" /v "AllowIdleIrpInD3" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "D3ColdSupported" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "DeviceIdleEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "DeviceSelectiveSuspended" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "EnableSelectiveSuspend" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "SystemWakeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "UserSetDeviceIdleEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "DefaultIdleState" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "fid_D1Latency" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "fid_D2Latency" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "fid_D3Latency" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "PerformanceIdleTime" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "LPMSupported" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "LPMEnable" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "SuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "PMEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "ExtPropDescSemaphore" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "LegacyTouchScaling" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i" /v "DisableWakeFromSuspend" /t REG_DWORD /d 1 /f >nul 2>&1
  reg add "%%i" /v "WriteReportExSupported" /t REG_DWORD /d 1 /f >nul 2>&1
  if exist "%%i\WDF" (
  reg add "%%i\WDF" /v "IdleInWorkingState" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i\WDF" /v "IdleEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "%%i\WDF" /v "PowerPolicyOwnershipEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
    )
)
echo [OK] All USB Enum device parameters patched

:: ── Per-hub scan via Win32_USBHub filtered on VID_ device IDs. Targets hub-level Device Parameters including latency overrides. ───────────────────────────────────────────────────────────
echo [*] Scanning USB Hubs (Win32_USBHub)...
for /F %%a in ('wmic path Win32_USBHub GET DeviceID ^| FINDSTR /L "VID_"') do (
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "fid_D1Latency" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "fid_D2Latency" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "fid_D3Latency" /t REG_DWORD /d 0 /f >nul 2>&1
)
echo [OK] USB Hub per-device power saving disabled

:: ── Extra pass on all USB + HID PnP entities via Win32_PnPEntity. Catches anything missed by the Enum\USB tree scan above. ─────────────────────────────────────────────────────────────────
echo [*] Scanning all USB + HID PnP entities (Win32_PnPEntity)...
for /f "delims=" %%i in ('wmic path Win32_PnPEntity GET DeviceID ^| FINDSTR /R "^USB\\ ^HID\\"') do (
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >nul 2>&1
)
echo [OK] All USB + HID PnP devices power saving disabled

:: ── Per PCI USB controller scan via CIM Win32_USBController. Also disables WDF IdleInWorkingState on each detected controller. ──────────────────────────────────────────────────────────────
echo [*] Scanning PCI USB Controllers (Win32_USBController)...
for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-CimInstance Win32_USBController | Where-Object { $_.PNPDeviceID -like ''PCI\VEN_*'' } | Select-Object -ExpandProperty PNPDeviceID"') do (
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\WDF" /v "IdleInWorkingState" /t REG_DWORD /d 0 /f >nul 2>&1
)
echo [OK] PCI USB Controller power saving disabled (incl. WDF IdleInWorkingState)

:: ── Disable power management on USB controllers and hubs via WMI. Uses MSPower_DeviceEnable to cut power management at the WMI layer. ────────────────────────────────────────────────────────
echo [*] Disabling PnP power management via WMI (MSPower_DeviceEnable)...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi;" ^
  "$usb_devices = @('Win32_USBController', 'Win32_USBControllerDevice', 'Win32_USBHub');" ^
  "foreach ($power_device in $power_device_enable) {" ^
  "    $instance_name = $power_device.InstanceName.ToUpper();" ^
  "    foreach ($device in $usb_devices) {" ^
  "        foreach ($hub in Get-WmiObject $device) {" ^
  "            $pnp_id = $hub.PNPDeviceID;" ^
  "            if ($instance_name -like \"*$pnp_id*\") {" ^
  "                $power_device.enable = $False; $power_device.psbase.put(); }}}}"
echo [OK] PnP power management disabled via WMI

:: ── Disable IdleEnable on legacy USB class subkeys 0000 through 0032. ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
echo [*] Disabling USB Class IdleEnable (legacy)...
for /L %%V in (0,1,32) do (
    if %%V LSS 10 (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Class\USB\000%%V" /v "IdleEnable" /t REG_DWORD /d 0 /f >nul 2>&1
    ) else (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Class\USB\00%%V" /v "IdleEnable" /t REG_DWORD /d 0 /f >nul 2>&1
    )
)
echo [OK] USB Class IdleEnable disabled (legacy)

:: ── Disable wake capability on HID mouse and keyboard devices via powercfg. May show SKIP if the device name differs on this system. ───────────────────────────────────────────────────────
echo [*] Disabling HID device wake capability...
powercfg -devicedisablewake "HID-compliant mouse"       && echo [OK] Wake disabled: HID-compliant mouse       || echo [SKIP] HID-compliant mouse not found
powercfg -devicedisablewake "HID-compliant mouse (001)" && echo [OK] Wake disabled: HID-compliant mouse (001) || echo [SKIP] HID-compliant mouse (001) not found
powercfg -devicedisablewake "HID Keyboard Device"       && echo [OK] Wake disabled: HID Keyboard Device       || echo [SKIP] HID Keyboard Device not found
powercfg -devicedisablewake "HID Keyboard Device (001)" && echo [OK] Wake disabled: HID Keyboard Device (001) || echo [SKIP] HID Keyboard Device (001) not found

echo.
echo [OK] Done. A restart is required to apply all changes.
echo.
pause
exit
