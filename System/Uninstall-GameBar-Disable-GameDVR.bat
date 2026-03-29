@echo off
:: Uninstall Xbox Game Bar + Disable Game DVR
:: Removes the Xbox Game Bar app and disables all background recording features.

winget uninstall "Xbox Game Bar" --silent >nul 2>&1
powershell -Command "Get-AppxPackage *XboxGamingOverlay* | Remove-AppxPackage" >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v HistoricalCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

echo Done.
pause
