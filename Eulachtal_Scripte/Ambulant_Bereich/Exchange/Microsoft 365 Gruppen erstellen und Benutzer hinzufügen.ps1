<#

 Mit diesem Script kannst du Microsoft 365 Gruppen erstellen.

 Ändere die folgenden Parameter nach deinen Wünschen:

 -DisplayName = Name der Gruppe
 
 -Alias = Alias
 
 -EmailAddress = Die Mail Adresse für die Gruppe

 - AccessType = Beitritts Typ (Private = Zutritt nur via Einladung / Public = Öffentlich zugänglich)
 
 Erstellen der Gruppe

 New-UnifiedGroup -DisplayName "Consumers Group" -Alias "0365Group-consumers" -EmailAddresses "ConsumersGroup@Crescent.com" -AccessType Private

 Löschen der Gruppe

  Remove-UnifiedGroup -Identity "Consumers Group" -confirm:$True

 #>


# Exchange Modul importieren

Import-Module ExchangeOnlineManagement


# Verbinden mit dem Online Exchange Server

Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


# Erstellen der Microsoft 365 Gruppe

New-UnifiedGroup -DisplayName Spitex-Leitungsteam -EmailAddresses spitex-leitungsteam@eulachtal.ch -AccessType Private


# Benutzer der Gruppe hinzufügen

Add-UnifiedGroupLinks -Identity spitex-leitungsteam@eulachtal.ch -LinkType Members -Links c.gruber@spitex-eulachtal.ch , y.mueller@spitex-eulachtal.ch , k.schild@spitex-eulachtal.ch , r.muenst@spitex-eulachtal.ch , r.germann@spitex-eulachtal.ch 


# Verbindung zum Exchange Online Server schliessen


Disconnect-ExchangeOnline -Confirm:$True


