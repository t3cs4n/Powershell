<#

 Massenmutation Benutzer zu Gruppe hinzufügen

#>


Import-Module ActiveDirectory

$csvPath = "C:\Powershell_Importe\Spitex\Spitex_User_Mailmigration.csv"
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    $groupName = "Lizenz_Microsoft_365_Business_Premium"
    $group = Get-ADGroup -Identity $groupName

    Add-ADGroupMember -Identity $group -Members $user.SAMAccountName
}