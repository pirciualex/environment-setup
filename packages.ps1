Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

$Packages = @(
    "7zip"
    "adobereader"
    "authy-desktop"
    "azure-cosmosdb-emulator"
    "azurestorageemulator"
    "calibre"
    "chocolatey-core.extension"
    "cpu-z"
    "deluge"
    "docker-cli"
    "docker-desktop"
    "discord"
    "dotnet-sdk"
    "dotnet-5.0-sdk"
    "dotnet-6.0-sdk"
    "epicgameslauncher"
    "etcher"
    "firefox"
    "geforce-experience"
    "gimp"
    "git"
    "go"
    "googlechrome"
    "inkscape"
    "joplin"
    "leagueoflegends"
    "microsoftazurestorageexplorer"
    "microsoft-teams"
    "microsoft-windows-terminal"
    "neovim"
    "nodejs-lts"
    "obs-studio"
    "pnpm"
    "postman"
    "potplayer"
    "powertoys"
    "putty"
    "python"
    "sharex"
    "signal"
    "spotify"
    "steam"
    "teamviewer"
    "virtualbox"
    "visualstudio2022community"
    "vscode"
    "xnviewmp"
)

foreach ($Package in $Packages) {
    Write-Host "Installing $Package..."
    choco install $Package -y
}


Write-Host "Installing zoho mail..."
Invoke-WebRequest -Uri "https://downloads.zohocdn.com/zmail-desktop/windows/zoho-mail-desktop-lite-installer-x64-v1.6.0.exe" -OutFile ".\zoho-mail-desktop-lite-installer.exe"
.\zoho-mail-desktop-lite-installer.exe


Write-Host "Copying windows terminal settings..."
Copy-Item -Path ".\settings.json" -Destination "C:\Users\$Env:UserName\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"


Write-Host "Opening common programs..."
Start-Process wt
Start-Process code
Start-Process -FilePath "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
Start-Process -FilePath "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
Start-Process -FilePath "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
Start-Process -FilePath "$env:ChocolateyInstall\lib\signal\tools\signal.bat"
Start-Process -FilePath "$env:LocalAppData\Microsoft\Teams\current\Teams.exe"


Write-Host "Setting git config..."
git config --global user.name "Alex Pirciu"
git config --global user.email "alex.pirciu@zohomail.eu"


Write-Host "Copying themes..."
$externalDrive = Get-Volume |
  Where-Object { $_.FileSystemLabel -like "Seagate*" } |
  Select DriveLetter
$sourceDirectory = "$($externalDrive.DriveLetter):\geamuri\themes"
Copy-item -Force -Recurse $sourceDirectory -Destination ".\"
./themes/theme.ps