do {
    $files = Get-ChildItem 'E:\TestEnv\deleted_images\' -recurse -include @("Image*") |
        Group-Object Name -AsHashTable

    $files.Values
    $userinput = Read-Host -Prompt 'Please Enter Folder name to be deleted'

    if ($files.ContainsKey($userinput)) {
        $files[$userinput] | Remove-item
        Write-Host 'Folder was deleted'
    }
}
until([string]::IsNullOrWhiteSpace($userinput))