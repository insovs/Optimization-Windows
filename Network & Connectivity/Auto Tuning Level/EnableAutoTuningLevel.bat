@echo off
echo Disabling autotuninglevel. & timeout /t 1 /nobreak >nul
netsh interface tcp set global autotuninglevel=normal
pause
