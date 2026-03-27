@echo off

rem # Windows Mitigations Disable Script [https://github.com/insovs]
rem # Disables all system-level mitigations including Spectre, Meltdown, SEHOP, CFG, DEP, ASLR, VBS, HVCI and related security components.

rem # This will significantly reduce system security.
rem # Use only if you know what you're doing or if you prioritize maximum performance and lowest latency above all.

title Disable Mitigations [https://github.com/insovs] & echo. & echo INFO: This will disable all system mitigations and security features. & echo. & set /p confirm=" Disable Mitigations ? [y/n]: "
if /i "%confirm%" neq "y" (echo. & echo  Aborted. & timeout /t 2 /nobreak > nul & exit /b) & echo. & echo  [*] Starting. & echo.

:: ── Process Mitigations (via PowerShell) ────────────────────────────────────────
:: Disables all available system process mitigations (DEP, CFG, ASLR, etc.)
powershell "ForEach($v in (Get-Command -Name 'Set-ProcessMitigation').Parameters['Disable'].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue; Write-Host 'Disabled: ' $v -ForegroundColor Green}"

:: ── Image File Execution Options ────────────────────────────────────────────────
powershell "Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*' -Recurse -ErrorAction SilentlyContinue" :: Removes all IFEO entries (often used by Defender/ETW to inject hooks)

:: ── BitLocker DMA Protection ────────────────────────────────────────────────────
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f :: Disables external DMA protection under BitLocker

:: ── Device Guard / VBS ──────────────────────────────────────────────────────────
:: Disables Virtualization Based Security (VBS)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f
:: Disables HVCI (Hypervisor Protected Code Integrity)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f

:: ── CPU Mitigations (Spectre / Meltdown) ────────────────────────────────────────
:: Disables Spectre Variant 2 and Meltdown mitigations (CVE-2017-5715 / CVE-2017-5754)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride"     /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings"            /t REG_DWORD /d "1" /f

:: ── Kernel Mitigations ──────────────────────────────────────────────────────────
:: Disables exception chain validation (SEHOP)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f
:: Disables kernel SEHOP
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled"              /t REG_DWORD /d "0" /f
:: Disables system object protection mode
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager"        /v "ProtectionMode"                  /t REG_DWORD /d "0" /f
:: Disables Control Flow Guard (CFG)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg"            /t REG_DWORD /d "0" /f
:: Disables all kernel MitigationOptions
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222"

echo. & echo  [OK] Done. A restart is required to apply the changes. & echo.
timeout /t 2 /nobreak > nul
pause





