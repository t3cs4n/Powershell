


import-csv -Path "C:\Powershell_Importe\Spitex\Spitex_User_Mailmigration.csv" 
| foreach {Get-ADUser $_.SamAccountName | Set-ADUser -add @{proxyaddresses = "SMTP:"+($_.MailAddress)}}