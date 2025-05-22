 
$users = Import-Csv "C:\Powershell_Importe\NoMail_Users.csv"


foreach ($user in $users) {
  Set-ADUser -Identity $user.SamAccountName -Replace @{mail=$user.MailAddress}
} 
