do {
$Path = 'E:\TestEnv\deleted_images\'
    $files = Get-ChildItem $Path -recurse -include @("Image*") |
        Group-Object Name -AsHashTable

    $files.Values
    $userinput = Read-Host -Prompt 'Please Enter Folder name to be deleted'

    if ($files.ContainsKey($userinput)) {
        $files[$userinput] | Remove-item
        Write-Host 'Folder was deleted'
    }
}
until([string]::IsNullOrWhiteSpace($userinput))