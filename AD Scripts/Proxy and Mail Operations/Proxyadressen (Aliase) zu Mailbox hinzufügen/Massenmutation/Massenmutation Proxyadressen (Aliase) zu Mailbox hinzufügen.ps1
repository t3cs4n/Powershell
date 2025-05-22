
To change the domain part of user principal names (UPNs) for multiple users using a CSV file in PowerShell, follow these steps:

Prepare the CSV file: Create a CSV file with two columns: SamAccountName and NewUPN. The SamAccountName column should contain the original SamAccountNames of the users, and the NewUPN column should contain the new UPNs with the desired domain part.

Import the Active Directory module: Import the Active Directory PowerShell module using the following command:

PowerShell
Import-Module ActiveDirectory
Verwende Code mit Vorsicht. Weitere Informationen

Read the CSV file: Import the CSV file into a PowerShell variable using the following command:
PowerShell
$users = Import-Csv -Path 'C:\Path\To\YourCSVFile.csv'
Verwende Code mit Vorsicht. Weitere Informationen

Change the UPNs: Loop through each user in the CSV file and change their UPN using the following code:
PowerShell
foreach ($user in $users) {
    $oldUPN = Get-ADUser -Identity $user.SamAccountName -Properties UserPrincipalName | Select-Object -ExpandProperty UserPrincipalName
    $newUPN = $user.NewUPN
    Set-ADUser -Identity $user.SamAccountName -UserPrincipalName $newUPN
    Write-Output "Changed UPN for user '$user.SamAccountName' from '$oldUPN' to '$newUPN'"
}
Verwende Code mit Vorsicht. Weitere Informationen

This code will loop through each user in the CSV file, retrieve their current UPN, set their new UPN using the Set-ADUser cmdlet, and print a message indicating the change.