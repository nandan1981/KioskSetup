
echo Starting Kiosk mode installation

Powershell.exe -executionpolicy remotesigned -File RegistryModification.ps1

REM Powershell.exe -executionpolicy remotesigned -File BIOSModification.ps1

Powershell.exe -executionpolicy remotesigned -File LaunchBrowser.ps1

echo Browser launched

REM Restart-Computer 

pause
