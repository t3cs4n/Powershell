while ($true) {

$ListFile = 'E:\TestEnv\deleted_images\'
 
get-childitem $ListFile -Filter 'Image*' -Recurse -Directory | Sort-Object -Property LastWriteTime


$Filename = Read-host -prompt "Bitte schreibe denn zu löschenden Ordner Namen"
$FilePath = Join-Path $ListFile $FileName
$FileExists =  test-path $FilePath 

If ($FileExists -eq $True) {
Remove-item $FilePath
Write-Host "Der Ordner wurde gelöscht " -ForegroundColor Green
}
} 
else {
        Write-Host "No directories found that match the filter.."
        break  # no directory by that name found, so exit the while loop
    }


Write-Host "All done" -ForegroundColor Green