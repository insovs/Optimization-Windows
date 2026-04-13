# Disable Power Management for all devices
# Disable "Allow the computer to turn off this device to save power"
# Disable "Allow this device to wake the computer"
# [https://github.com/insovs]

$wake = Get-CimInstance -Query 'SELECT InstanceName FROM MSPower_DeviceWakeEnable WHERE (Enable = True)' -Namespace 'root\WMI'
if ($wake) { foreach ($d in $wake) { Set-CimInstance -InputObject $d -Property @{Enable = $false}; Write-Host "[OK] $($d.InstanceName)" } } else { Write-Host "[SKIP] No devices with wake capability enabled." }

$power = Get-CimInstance -Query 'SELECT InstanceName FROM MSPower_DeviceEnable WHERE (Enable = True)' -Namespace 'root\WMI'
if ($power) { foreach ($d in $power) { Set-CimInstance -InputObject $d -Property @{Enable = $false}; Write-Host "[OK] $($d.InstanceName)" } } else { Write-Host "[SKIP] No devices with power management enabled." }

Write-Host "`n[OK] Done. A restart is required to apply all changes."
cmd /c 'pause'
