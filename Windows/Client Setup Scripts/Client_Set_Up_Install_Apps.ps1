     <#

     This script will run as administrator & do the following tasks:
  
     -Set Security Protocol Tls12
     -Install winget newest version
     -Install all client apps to Scope machine (AllUsers)

    #>

    # Code to make sure a script is running with full admin privileges.

    param([switch]$Elevated)

    function Test-Admin {
        $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
        $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }

    if ((Test-Admin) -eq $false)  {
        if ($elevated) {
            # tried to elevate, did not work, aborting
        } else {
            Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
        }
        exit
    }

    Write-Host "Running with full priviliges" -ForegroundColor Red -BackgroundColor Yellow
    

    # Set TLS Level 1.2


    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Install-PackageProvider -Name NuGet

    # Install latest winget module

    # get latest download url

    $URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
            Select-Object -ExpandProperty "assets" |
            Where-Object "browser_download_url" -Match '.msixbundle' |
            Select-Object -ExpandProperty "browser_download_url"

    # download

    Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing

    # install

    Add-AppxPackage -Path "Setup.msix"

    # delete file
    
    Remove-Item "Setup.msix"


    # winget install -e --id Microsoft.VCRedist.2015+.x64


    pause


    Write-Host "Installing Winrar for AllUsers" -ForegroundColor Red -BackgroundColor Yellow


    winget install --id=RARLab.WinRAR  -e --silent --scope machine 



    pause


    Write-Host "Installing Abaclient for AllUsers" -ForegroundColor Red -BackgroundColor Yellow


    winget install --id=Abacus.AbaClient  -e --silent --scope machine 



    # winget install --id=Google.Chrome -e --silent --scope machine


    pause


    # winget install --id=Mozilla.Firefox -e --silent --scope machine


    pause


    Write-Host "Installing PDF24 for AllUsers" -ForegroundColor Red -BackgroundColor Yellow


    winget install --id=geeksoftwareGmbH.PDF24Creator -e --silent --scope machine


    pause


    # winget install --id=Notepad++.Notepad++  -e --silent --scope machine

    pause
 
