<#

 Mit diesem Script kannst du Mail Kontakte auf Exchange Online erstellen.

 Die Benutzer werden von einer CSV Datei importiert (mailcontacts.csv)

 Bearbeite zuerst diese in dem du alle Benutzer mit den nötigen Angaben erfasst,
 für die ein Mail Kontakt erstellt werden soll.


 #>


# Exchange Modul importieren

Import-Module ExchangeOnlineManagement


# Verbinden mit dem Online Exchange Server

Connect-ExchangeOnline -UserPrincipalName admin@pflegeeulachtal.onmicrosoft.com


# Importieren der Personen aus der CSV Datei und erstellen der Mail Kontakte.


import-csv \\netapp01\daten\03_IT\01._Powershell_Scripts\Eulachtal_Scripte\Exchange_Online\Create_Contacts\ExternalContacts.csv | ForEach-Object {New-MailContact -Name $_.Name -DisplayName $_.Name -ExternalEmailAddress $_.ExternalEmailAddress -FirstName $_.FirstName -LastName $_.LastName}