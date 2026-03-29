# Disable Hibernation
# Disables hibernation, removes hiberfil.sys and frees up disk space.

powercfg -h off

$path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'
Set-ItemProperty -Path $path -Name 'HibernateEnabled'        -Value 0 -Type DWord -Force
Set-ItemProperty -Path $path -Name 'HibernateEnabledDefault' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $path -Name 'HiberFileSizePercent'    -Value 0 -Type DWord -Force

Write-Host "Hibernation disabled." -ForegroundColor Green
