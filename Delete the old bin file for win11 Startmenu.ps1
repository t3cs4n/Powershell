<#


 Delete the old bin file for win11 Startmenu


#>

$filePath = "C:\Users\Admin\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin"

# Check if the file exists
if (Test-Path $filePath) {
    # Delete the file
    Remove-Item -Path $filePath -Force

    Write-Host "File has been deleted successfully."
} else {
    Write-Host "The file does not exist."
}

pause



