<#


 Gruppenmitgliedschaften eines Benutzers auslesen

 Erstze den Wert "username" .

 Beispiel : Get-ADPrincipalGroupMembership miguel.santiago | select name


#>





Get-ADPrincipalGroupMembership "username" | Select-Object name