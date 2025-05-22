<#

 Bulk Remove all Proxy Addresses

#>

$users = Import-Csv "C:\Powershell_Importe\Spitex\Spitex_User_Mailmigration.csv"


foreach ($user in $users) {
Set-ADUser -Identity $user.SamAccountName -clear proxyAddresses
} 
