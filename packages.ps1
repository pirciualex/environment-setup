Function Add-PathVariable {
    param (
        [string]$pathToAdd
    )
    if (-Not (Test-Path $pathToAdd)) {
		Write-Host "$pathToAdd is not a valid path"
		return
    }
	
	$regexPath = [regex]::Escape($pathToAdd)
    $arrPath = $env:Path -split ';' | Where-Object {$_ -match "^$regexPath\\?"}
	if($arrPath) {
		Write-Host "$pathToAdd is already added to PATH"
		return
	}
	
	[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$pathToAdd", "Machine")
}


Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

$Packages = @(
    "7zip"
    "adobereader"
    "azure-cosmosdb-emulator"
    "calibre"
    "chocolatey-core.extension"
    "cpu-z"
    "deluge"
    "discord"
    "docker-cli"
    "docker-desktop"
    "dotnet-sdk"
    "dotnet-6.0-sdk"
    "epicgameslauncher"
    "etcher"
    "fd"
    "firefox"
    "geforce-experience"
    "gimp"
    "git"
    "go"
    "googlechrome"
    "helix"
    "inkscape"
    "joplin"
    "koodo-reader"
    "lazygit"
    # "leagueoflegends"
    "lf"
    "microsoftazurestorageexplorer"
    "microsoft-teams"
    "microsoft-windows-terminal"
    "mingw"
    "neovim"
    "nodejs-lts"
    "obs-studio"
    "pnpm"
    "potplayer"
    "powertoys"
    "python"
    "ripgrep"
    "sharex"
    "signal"
    "spotify"
    "steam"
    "teamviewer"
    "virtualbox"
    "visualstudio2022community"
    "vscode"
    "windirstat"
    "xnviewmp"
    "zoom"
)

foreach ($Package in $Packages) {
    Write-Host "Installing $Package..."
    choco install $Package -y
}


Write-Host "Installing zoho mail..."
Invoke-WebRequest -Uri "https://downloads.zohocdn.com/zmail-desktop/windows/zoho-mail-desktop-lite-installer-x64-v1.6.4.exe" -OutFile ".\zoho-mail-desktop-lite-installer.exe"
.\zoho-mail-desktop-lite-installer.exe


Write-Host "Adding PATH environment variables..."
Add-PathVariable("$env:ProgramFiles\Mozilla Firefox")
Add-PathVariable("$env:ProgramFiles\Git\bin")
Add-PathVariable("$env:ProgramFiles\Microsoft VS Code\bin")
Add-PathVariable("$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator")
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

Write-Host "Copying config files..."
Copy-Item -Force -Path ".\.gitconfig" -Destination "$env:USERPROFILE"
Copy-Item -Force -Path ".\.bash_profile" -Destination "$env:USERPROFILE"
Copy-Item -Force -Path ".\.bashrc" -Destination "$env:USERPROFILE"
$helixDirectory = "$env:APPDATA\helix"
if (!(Test-Path -path $helixDirectory)) {
    New-Item $helixDirectory -Type Directory
}
Copy-Item -Force -Recurse -Path ".\helix\*" -Destination "$helixDirectory"
$lfDirectory = "$env:LocalAppData\lf"
if (!(Test-Path -path $lfDirectory)) {
    New-Item $lfDirectory -Type Directory
}
Copy-Item -Force -Path ".\lf\lfrc" -Destination "$lfDirectory"
Copy-Item -Force -Path ".\settings.json" -Destination "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"


Write-Host "Opening common programs..."
Start-Process wt
Start-Process code
Start-Process -FilePath "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
Start-Process firefox
Start-Process -FilePath "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
Start-Process -FilePath "$env:ChocolateyInstall\lib\signal\tools\signal.bat"
Start-Process -FilePath "$env:LocalAppData\Microsoft\Teams\current\Teams.exe"


Write-Host "Copying themes..."
$externalDrive = Get-Volume |
  Where-Object { $_.FileSystemLabel -like "Seagate*" } |
  Select DriveLetter
$sourceDirectory = "$($externalDrive.DriveLetter):\geamuri\themes"
Copy-item -Force -Recurse $sourceDirectory -Destination ".\"
./themes/theme.ps
