@echo off
:: Uninstall & Disable Xbox Game Bar
:: Removes the Xbox Game Bar features, auto-start, notifications and overlays.

:: ── Uninstall ─────────────────────────────────────────────────────────────────
winget uninstall "Xbox Game Bar" --silent >nul 2>&1
powershell -Command "Get-AppxPackage *XboxGamingOverlay* | Remove-AppxPackage" >nul 2>&1

:: ── Disable GameBar via user settings ─────────────────────────────────────────
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d 0 /f >nul 2>&1

:: ── Remove Xbox Game Bar auto-start entry ─────────────────────────────────────
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "XboxGameBar" /f >nul 2>&1

:: ── Disable notifications related to Xbox Game Bar ────────────────────────────
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe!App" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: ── Remove scheduled task for GameBar (if present) ────────────────────────────
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\GameBar" /f >nul 2>&1

echo Done.
pause