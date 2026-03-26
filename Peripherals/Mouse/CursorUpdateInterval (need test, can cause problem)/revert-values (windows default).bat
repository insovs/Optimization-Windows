@echo off
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v CursorUpdateInterval /t REG_DWORD /d 5 /f
echo press any key for quit.
pause>nul