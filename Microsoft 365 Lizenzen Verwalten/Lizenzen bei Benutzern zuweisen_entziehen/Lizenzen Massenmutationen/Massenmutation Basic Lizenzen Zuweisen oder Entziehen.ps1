


Install-Module -Name Microsoft.Graph

    # Importiere das Microsoft Graph PowerShell SDK
Import-Module Microsoft.Graph

# Melde dich an deinem Microsoft 365-Mandanten an
Connect-MsolService

# Öffne die CSV-Datei
$csv = Import-Csv -Path "C:\Powershell_Importe\Business Basic Remove.csv"

# Gehe durch die Liste der Benutzer
foreach ($user in $csv) {

    # Hole den Benutzer aus dem Microsoft Graph
    $user = Get-MsolUser -UserPrincipalName $user.UserPrincipalName

    # Entferne die Microsoft 365 Business Basic-Lizenz
    Remove-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -Licenses "Microsoft 365 Business Basic"

}