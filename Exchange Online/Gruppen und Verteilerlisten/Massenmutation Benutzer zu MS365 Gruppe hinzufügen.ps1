
$365Logon = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $365Logon -Authentication Basic -AllowRedirection
Import-PSSession $Session

Import-CSV "C:\members.csv" | ForEach-Object {
    Add-UnifiedGroupLinks –Identity "O365Group" –LinkType Members  –Links $_.member
    }

    