Write-Host "Creating Restore Point incase something bad happens..."
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"

Write-Host "Running O&O Shutup with Restrictive Settings..."
Import-Module BitsTransfer
Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
./OOSU10.exe ooshutup10.cfg /quiet

./telemetry.ps1

./bloatware.ps1

./system-config.ps1

./packages.ps1