# Mitglieder einer spezifischen Azure AD Sicherheitsgruppe auslesen und auf Wunsch in CSV exportieren


# Install-Module -Name AzureAD

Connect-AzureAD


# Setzen Sie den Namen oder die ID der Gruppe, deren Mitglieder exportiert werden sollen
$GroupName = "365_Standard_Lizenz"

# Holen Sie sich die Gruppen-ID anhand des Gruppennamens
$Group = Get-AzureADGroup -SearchString $GroupName

# Holen Sie sich die Mitglieder der Gruppe
$Members = Get-AzureADGroupMember -ObjectId $Group.ObjectId

# Exportieren Sie die Mitglieder in die GridView
# $Members | Select-Object DisplayName, UserPrincipalName | Out-GridView


# Exportieren Sie die Mitglieder in eine CSV-Datei
$Members | Select-Object DisplayName, UserPrincipalName | Export-Csv -Path "C:\AzureADExports\Members_365_Standard_Lizenz.csv" -NoTypeInformation

