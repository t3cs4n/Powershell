<#


  Install Apps Only (without winget)


#>


 Write-Host "Installing Winrar for AllUsers" -ForegroundColor Red -BackgroundColor Yellow


    winget install --id=RARLab.WinRAR  -e --silent --scope machine 



    pause


    # Write-Host "Installing Abaclient for AllUsers" -ForegroundColor Red -BackgroundColor Yellow


    # winget install --id=Abacus.AbaClient  -e --silent --scope machine 



    # winget install --id=Google.Chrome -e --silent --scope machine


    pause


    # winget install --id=Mozilla.Firefox -e --silent --scope machine


    pause


    # Write-Host "Installing PDF24 for AllUsers" -ForegroundColor Red -BackgroundColor Yellow


    # winget install --id=geeksoftwareGmbH.PDF24Creator -e --silent --scope machine


    pause


    Write-Host "Installing Notepadd ++" -ForegroundColor Red -BackgroundColor Yellow


    winget install --id=Notepad++.Notepad++  -e --silent --scope machine




    pause
 
