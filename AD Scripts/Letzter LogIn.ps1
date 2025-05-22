#Quelle: https://www.windows-faq.de/2018/08/04/lastlogon-letzter-login-eines-users-im-ad-feststellen-per-get-aduser/

Import-Module ActiveDirectory


Get-ADUser „stfr“ -Properties LastLogonDate | Format-Table -Property Name, LastLogonDate -A


#Alle User oder Computer auflisten 
#Get-ADUser -Filter {Enabled -eq $true} -Properties * | Sort LastLogonDate | FT Name, LastLogonDate
#Get-ADComputer -Filter {Enabled -eq $true}  -Properties * | Sort LastLogonDate | FT Name, LastLogonDate
