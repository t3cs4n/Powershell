do {

$ListFile = 'E:\TestEnv\deleted_images\'

get-childitem $ListFile -Filter 'Image*' -Recurse -Directory | select LastWriteTime,name
 Group-Object Name -AsHashTable

    $userinput = Read-Host -Prompt 'Please Enter Folder name to be deleted'

    if ($files.ContainsKey($userinput)) {
        $files[$userinput] | Remove-item
        Write-Host 'Folder was deleted'
    }
}
until([string]::IsNullOrWhiteSpace($userinput))