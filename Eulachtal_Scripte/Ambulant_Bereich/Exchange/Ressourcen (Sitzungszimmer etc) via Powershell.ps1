# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


Get-CalendarProcessing -Identity Sitzungszimmer_EG | Format-List