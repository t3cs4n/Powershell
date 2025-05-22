<#

 Autor : Miguel Santiago

 Mit diesem Script kannst du dir anzeigen lassen, bei welchen Benutzerkontos aus einer bestimmten Organisations Einheit (OU) 
 die Einstellung "Passwort läuft nie ab" aktiviert ist. Durch Änderung des Wertes TRUE auf FALSE, kannst du dir auch das 
 Gegenteil anzeigen lassen, also bei welchen Benutzerkontos die Einstellung nicht aktiviert ist.

 Die OU kannst du anpassen in dem du in den Attributen der OU den Wert des Attributs "distinguishedName" kopierst.
 Ersetze mit dem Inhalt des Werte Felds, den braunen Text innerhalt der Anführungszeichen nach -SearchBase.

 Zeile 21 ist der Code für aktiviert und Zeile 24 für nicht aktiviert


 Das ganze wird in die GridView (ein tabellarisch dargestelltes Fenster) ausgegeben.


#>


Get-ADUser -SearchBase „OU=Benutzer,OU=Eulachtal Spitex,DC=eulachtal,DC=zh“ -Filter 'PasswordNeverExpires -eq $TRUE' -Properties PasswordNeverExpires | Out-GridView 


Get-ADUser -SearchBase „OU=Benutzer,OU=Eulachtal Spitex,DC=eulachtal,DC=zh“ -Filter 'PasswordNeverExpires -eq $FALSE' -Properties PasswordNeverExpires | Out-GridView 


# Dieses Script wurde anhand dieser Internet Seite gebaut : https://www.windowspro.de/script/passwort-einstellungen-powershell-kennwort-laeuft-nie-ab-passwort-nicht-erforderlich