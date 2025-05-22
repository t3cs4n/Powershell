<#

 Autor : Miguel Santiago

 Mit diesem Script kannst du die Benutzerobjekte in einer Organisations Einheit (OU) exportieren und zusätzlich das Attribut Emailadresse auslesen.
 Die OU aus welcher du die Benutzer exportieren willst kannst du nach belieben anpassen.
 Passe dazu den Pfad der $OU Variable an. Im folgenden Beispiel werden alle Benutzer aus der OU "Benutzer Alle" exportiert. 

 Führe erst die Zeile 16 aus um die Variable zu setzten.

#>



$OU = 'OU=Benutzer_Alle,OU=Benutzer,OU=EULACHTAL,DC=EULACHTAL,DC=ZH'


Get-ADUser -Filter * -SearchBase $OU -Properties EmailAddress | Select-Object Name, EmailAddress | Out-GridView


Get-ADUser -Filter * -SearchBase $OU -Properties EmailAddress | Select-Object Name, EmailAddress | Export-Csv -Path \\netapp01\daten\03_IT\000._AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\Email-Adressen_Mitarbeiter_Eulachtal.csv -Encoding UTF8


# Original Code : Get-ADUser -Filter * -SearchBase $OU -Properties EmailAddress | Select-Object Name, EmailAddress | Export-Csv -Path c:\Email_Adresse_Mitarbeiter_Eulachtal.csv -Encoding UTF8
