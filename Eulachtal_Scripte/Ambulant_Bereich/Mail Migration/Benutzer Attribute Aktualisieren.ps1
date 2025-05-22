




Import-Csv -Path "C:\path\to\your\csv\file.csv" -Delimiter "," | ForEach-Object {
    Set-ADUser -Identity $_.UserPrincipalName -DisplayName $_.NewDisplayName
}

