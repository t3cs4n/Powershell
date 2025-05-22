<#

 Mit diesem Script kannst du Mail Kontakte auf Exchange Online erstellen.

 Die Benutzer werden von einer CSV Datei importiert (mailcontacts.csv)

 Bearbeite zuerst diese in dem du alle Benutzer mit den nötigen Angaben erfasst,
 für die ein Mail Kontakt erstellt werden soll.


 #>


# Exchange Modul importieren

Import-Module ExchangeOnlineManagement


# Verbinden mit dem Online Exchange Server

Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


# Importieren der Personen aus der CSV Datei und erstellen der Mail Kontakte.


import-csv C:\Users\administrator.EULACHTAL\Desktop\Create_Contacts\MailContacts.csv | foreach {New-MailContact -Name $_.name -ExternalEmailAddress $_.externalemailaddress -Alias $_.alias }