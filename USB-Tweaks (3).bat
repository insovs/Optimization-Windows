@echo off & title USB Tweaks

rem # Disables USB power saving features for lower latency and stable input.
rem # WARNING: May increase power consumption on laptops.

:: Auto-elevate to admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo. & echo [*] Starting USB power saving disable sequence. & echo.

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - Global USB enum key
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] Enum\USB AllowIdleIrpInD3 || echo [ERROR] Enum\USB AllowIdleIrpInD3
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /v "D3ColdSupported" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] Enum\USB D3ColdSupported || echo [ERROR] Enum\USB D3ColdSupported
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] Enum\USB DeviceSelectiveSuspended || echo [ERROR] Enum\USB DeviceSelectiveSuspended
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] Enum\USB EnableSelectiveSuspend || echo [ERROR] Enum\USB EnableSelectiveSuspend
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] Enum\USB EnhancedPowerManagementEnabled || echo [ERROR] Enum\USB EnhancedPowerManagementEnabled
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] Enum\USB SelectiveSuspendEnabled || echo [ERROR] Enum\USB SelectiveSuspendEnabled
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] Enum\USB SelectiveSuspendOn || echo [ERROR] Enum\USB SelectiveSuspendOn

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - Per USB Hub Device (wmic Win32_USBHub)
:: ---------------------------------------------------------------------------
for /F %%a in ('wmic path Win32_USBHub GET DeviceID^| FINDSTR /L "VID_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "fid_D1Latency" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "fid_D2Latency" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "fid_D3Latency" /t REG_DWORD /d "0" /f >nul 2>&1
)
echo [OK] USB Hub per-device power saving disabled

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - All PnP Devices brute force (Win32_PnPEntity)
rem # Covers any USB device missed by the targeted loops above
:: ---------------------------------------------------------------------------
for /f "delims=" %%i in ('wmic path Win32_PnPEntity GET DeviceID^| FINDSTR /R "^USB\\ ^HID\\"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f >nul 2>&1
)
echo [OK] All USB + HID PnP devices power saving disabled (brute force)

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - Per PCI USB Controller (PowerShell CIM) + WDF IdleInWorkingState
:: ---------------------------------------------------------------------------
for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-CimInstance Win32_USBController | Where-Object { $_.PNPDeviceID -like ''PCI\VEN_*'' } | Select-Object -ExpandProperty PNPDeviceID"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\WDF" /v "IdleInWorkingState" /t REG_DWORD /d "0" /f >nul 2>&1
)
echo [OK] PCI USB Controller per-device power saving disabled (incl. WDF IdleInWorkingState)

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - usbflags latency
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "fid_D1Latency" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] usbflags fid_D1Latency || echo [ERROR] usbflags fid_D1Latency
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "fid_D2Latency" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] usbflags fid_D2Latency || echo [ERROR] usbflags fid_D2Latency
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "fid_D3Latency" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] usbflags fid_D3Latency || echo [ERROR] usbflags fid_D3Latency
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "DisableHCS0Idle" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] usbflags DisableHCS0Idle || echo [ERROR] usbflags DisableHCS0Idle
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "IgnoreHWSerNum" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] usbflags IgnoreHWSerNum || echo [ERROR] usbflags IgnoreHWSerNum

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - USB service
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisablePowerDown" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USB DisablePowerDown || echo [ERROR] USB DisablePowerDown
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USB DisableSelectiveSuspend || echo [ERROR] USB DisableSelectiveSuspend
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "EnIdleEndpointSupport" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] USB EnIdleEndpointSupport || echo [ERROR] USB EnIdleEndpointSupport
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USB\Parameters DisableSelectiveSuspend || echo [ERROR] USB\Parameters DisableSelectiveSuspend
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB\Parameters" /v "DisableSelectiveSuspendTimeout" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USB\Parameters DisableSelectiveSuspendTimeout || echo [ERROR] USB\Parameters DisableSelectiveSuspendTimeout
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB\Parameters" /v "DisableZeroLengthControlTransfers" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USB\Parameters DisableZeroLengthControlTransfers || echo [ERROR] USB\Parameters DisableZeroLengthControlTransfers
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB\Parameters" /v "ForceFullSpeed" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USB\Parameters ForceFullSpeed || echo [ERROR] USB\Parameters ForceFullSpeed
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB\Parameters" /v "ForceHCResetOnResume" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USB\Parameters ForceHCResetOnResume || echo [ERROR] USB\Parameters ForceHCResetOnResume

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - USBXHCI (xHCI controller)
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "DisableLegacyUSBSupport" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBXHCI DisableLegacyUSBSupport || echo [ERROR] USBXHCI DisableLegacyUSBSupport
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBXHCI DisableSelectiveSuspend || echo [ERROR] USBXHCI DisableSelectiveSuspend
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] USBXHCI EnhancedPowerManagementEnabled || echo [ERROR] USBXHCI EnhancedPowerManagementEnabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "ForceFullSpeed" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBXHCI ForceFullSpeed || echo [ERROR] USBXHCI ForceFullSpeed
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "IdleEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] USBXHCI IdleEnabled || echo [ERROR] USBXHCI IdleEnabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "LowLatencyMode" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBXHCI LowLatencyMode || echo [ERROR] USBXHCI LowLatencyMode
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] USBXHCI SelectiveSuspendEnabled || echo [ERROR] USBXHCI SelectiveSuspendEnabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters\Wdf" /v "NoExtraBufferRoom" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] USBXHCI\Wdf NoExtraBufferRoom || echo [ERROR] USBXHCI\Wdf NoExtraBufferRoom
reg add "HKLM\SYSTEM\ControlSet001\Services\USBXHCI\Parameters\Device" /v "InterruptThreshold" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBXHCI InterruptThreshold || echo [ERROR] USBXHCI InterruptThreshold

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - USBHUB / USBHUB3
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\hubg" /v "DisableOnSoftRemove" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] usbhub\hubg DisableOnSoftRemove || echo [ERROR] usbhub\hubg DisableOnSoftRemove
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters" /v "DisableOnSoftRemove" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] usbhub\Parameters DisableOnSoftRemove || echo [ERROR] usbhub\Parameters DisableOnSoftRemove
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters" /v "EnableAggressiveSuspend" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] usbhub\Parameters EnableAggressiveSuspend || echo [ERROR] usbhub\Parameters EnableAggressiveSuspend
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters" /v "SelectiveSuspendTimeout" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] usbhub\Parameters SelectiveSuspendTimeout || echo [ERROR] usbhub\Parameters SelectiveSuspendTimeout
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters" /v "IoQueueWorkItem" /t REG_DWORD /d "0x0000000a" /f >nul 2>&1 && echo [OK] usbhub\Parameters IoQueueWorkItem || echo [ERROR] usbhub\Parameters IoQueueWorkItem
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBHUB3 DisableSelectiveSuspend || echo [ERROR] USBHUB3 DisableSelectiveSuspend
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] USBHUB3 EnhancedPowerManagementEnabled || echo [ERROR] USBHUB3 EnhancedPowerManagementEnabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "ForceFullSpeed" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBHUB3 ForceFullSpeed || echo [ERROR] USBHUB3 ForceFullSpeed
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "LowLatencyMode" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBHUB3 LowLatencyMode || echo [ERROR] USBHUB3 LowLatencyMode
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] USBHUB3 SelectiveSuspendEnabled || echo [ERROR] USBHUB3 SelectiveSuspendEnabled
reg add "HKLM\SYSTEM\ControlSet001\Services\USBHUB3\Parameters\Device" /v "InterruptThreshold" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] USBHUB3 InterruptThreshold || echo [ERROR] USBHUB3 InterruptThreshold

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - HidUsb / xusb22
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Services\HidUsb" /v "IdleEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] HidUsb IdleEnabled || echo [ERROR] HidUsb IdleEnabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\xusb22\Parameters" /v "IoQueueWorkItem" /t REG_DWORD /d "0x0000000a" /f >nul 2>&1 && echo [OK] xusb22 IoQueueWorkItem || echo [ERROR] xusb22 IoQueueWorkItem
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "IoQueueWorkItem" /t REG_DWORD /d "0x0000000a" /f >nul 2>&1 && echo [OK] USBXHCI IoQueueWorkItem || echo [ERROR] USBXHCI IoQueueWorkItem

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - usbaudio
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbaudio\Parameters" /v "AudioAlwaysOn" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] usbaudio AudioAlwaysOn || echo [ERROR] usbaudio AudioAlwaysOn
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbaudio\Parameters" /v "IsochronousTransferMode" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] usbaudio IsochronousTransferMode || echo [ERROR] usbaudio IsochronousTransferMode
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbaudio\Parameters" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1 && echo [OK] usbaudio Latency || echo [ERROR] usbaudio Latency

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - USB Class IdleEnable (legacy)
:: ---------------------------------------------------------------------------
for /L %%V in (0,1,32) do (
    if %%V LSS 10 (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Class\USB\000%%V" /v "IdleEnable" /t REG_DWORD /d "0" /f >nul 2>&1
    ) else (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Class\USB\00%%V" /v "IdleEnable" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)
echo [OK] USB Class IdleEnable disabled (legacy)

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - StorPort log
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorPort" /v "LogControlEnable" /t REG_QWORD /d "0" /f >nul 2>&1 && echo [OK] StorPort LogControlEnable || echo [ERROR] StorPort LogControlEnable

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - Surprise removal / AttemptRecovery
:: ---------------------------------------------------------------------------
reg add "HKLM\SYSTEM\CurrentControlSet\Control\USB\AutomaticSurpriseRemovals" /v "AttemptRecoveryFromUsbPowerDrain" /t REG_DWORD /d "0" /f >nul 2>&1 && echo [OK] AttemptRecoveryFromUsbPowerDrain || echo [ERROR] AttemptRecoveryFromUsbPowerDrain

:: ---------------------------------------------------------------------------
rem # Disable USB Power Saving - PnP power management via WMI (all devices)
:: ---------------------------------------------------------------------------
echo [*] Disabling PnP power management via WMI...
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

:: ---------------------------------------------------------------------------
rem # Disable "Allow this device to wake the computer" - HID devices
:: ---------------------------------------------------------------------------
powercfg -devicedisablewake "HID-compliant mouse" >nul 2>&1 && echo [OK] Wake disabled: HID-compliant mouse || echo [SKIP] HID-compliant mouse not found
powercfg -devicedisablewake "HID-compliant mouse (001)" >nul 2>&1 && echo [OK] Wake disabled: HID-compliant mouse (001) || echo [SKIP] HID-compliant mouse (001) not found
powercfg -devicedisablewake "HID Keyboard Device" >nul 2>&1 && echo [OK] Wake disabled: HID Keyboard Device || echo [SKIP] HID Keyboard Device not found
powercfg -devicedisablewake "HID Keyboard Device (001)" >nul 2>&1 && echo [OK] Wake disabled: HID Keyboard Device (001) || echo [SKIP] HID Keyboard Device (001) not found

echo.
echo [OK] Done. A restart is required to apply the changes.
echo.
pause
exit
