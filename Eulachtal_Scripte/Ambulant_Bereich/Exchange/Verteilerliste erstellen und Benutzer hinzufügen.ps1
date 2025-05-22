<#

 Mit diesem Script kannst du Verteilerlisten erstellen.

 Ändere die folgenden Parameter nach deinen Wünschen:

 -DisplayName = Name der Gruppe
 
 -Alias = Alias
 
 -EmailAddress = Die Mail Adresse für die Gruppe

 - AccessType = Beitritts Typ (Private = Zutritt nur via Einladung / Public = Öffentlich zugänglich)
 

 Erstellen der Verteilerliste


 New-DistributionGroup -Name "Sales Managers" -Alias "SalesMgrs" -PrimarySmtpAddress "SalesManagers@Crescent.com" -Type Distribution


 Löschen der Verteilerliste
 

 Remove-DistributionGroup -Identity "Sales Managers" -Confirm:$True



 #>


# Exchange Modul importieren

Import-Module ExchangeOnlineManagement


# Verbinden mit dem Online Exchange Server

Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


# Erstellen der Verteilerliste

New-DistributionGroup -Name Spitex-Leitungsteam -PrimarySmtpAddress spitex-leitungsteam@eulachtal.ch -Type Distribution


# Benutzer der Gruppe hinzufügen

$Members = @("f.pregowski@spitex-eulachtal.ch")

$Members | ForEach-Object {
    Add-DistributionGroupMember -Identity Spitex-Leitungsteam -Member $_
    Write-Host "Added Member:"$_
}


# Verbindung zum Exchange Online Server schliessen


Disconnect-ExchangeOnline -Confirm:$True


