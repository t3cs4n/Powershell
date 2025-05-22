do {


$destination = 'E:\TestEnv\deleted_images'
$ListFile = 'E:\TestEnv\Repository\images\' 
get-childitem $ListFile
$Filename = Read-host -prompt "Please Enter File to be moved"
$FilePath = Join-Path $ListFile $FileName
$FileExists =  test-path $FilePath 

If ($FileExists -eq $True) {
move-item $FilePath $destination
Write-Host "File is moved to $destination "
}
} while($Filename -match'.+')

