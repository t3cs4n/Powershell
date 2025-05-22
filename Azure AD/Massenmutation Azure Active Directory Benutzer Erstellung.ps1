<#

 Massenmutation Azure Active Directory Benutzer Erstellung

#>

Import-Module AzureAD

$csvFile = "C:\Users\Administrator\Desktop\users.csv"

$users = Import-CSV -Path $csvFile

foreach ($user in $users) {
    New-AzureADUser -DisplayName $user.DisplayName -UserPrincipalName $user.UserPrincipalName -Password $user.Password
}