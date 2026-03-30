# Disable Hibernation
# Disables hibernation, removes hiberfil.sys, disables Fast Startup, and improves system stability.

powercfg -h off

# Optional registry enforcement
# Ensures hibernation and Fast Startup remain disabled system-wide.

$path1 = 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'
Set-ItemProperty -Path $path1 -Name 'HibernateEnabled'        -Value 0 -Type DWord -Force
Set-ItemProperty -Path $path1 -Name 'HibernateEnabledDefault' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $path1 -Name 'HiberFileSizePercent' -Value 0 -Type DWord -Force

$path2 = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power'
Set-ItemProperty -Path $path2 -Name 'HiberbootEnabled' -Value 0 -Type DWord -Force

Write-Host "Hibernation disabled." -ForegroundColor Green
pause
