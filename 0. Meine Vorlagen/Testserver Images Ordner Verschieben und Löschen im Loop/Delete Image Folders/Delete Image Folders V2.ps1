do {
    $files = Get-ChildItem | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-15)}
        Group-Object Name -AsHashTable

    $files.Values
    $userinput = Read-Host -Prompt 'Please Enter Folder name to be deleted'

    if ($files.ContainsKey($userinput)) {
        $files[$userinput] | Remove-item
        Write-Host 'Folder was deleted'
    }
}
until([string]::IsNullOrWhiteSpace($userinput))