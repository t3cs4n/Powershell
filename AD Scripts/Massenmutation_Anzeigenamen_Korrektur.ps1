
# Import the Active Directory module
Import-Module ActiveDirectory

# Path to the CSV file containing user information

Import-Csv -Path "C:\Powershell_Importe\TV_Anzeigenamen_Korrektur.csv" 

foreach ($user in $users) 

{
  Rename-ADObject -Identity $user.SamAccountName -NewName $user.NewName 


}