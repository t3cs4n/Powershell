<#

 Mit diesem Script kannst du die existierenden Masilboxen vom Exchange Server Online
 zu einer CSV-Datei exportieren.

 Mit der Zeile welche mit Out-Gridview endet, kannst du den Export erst mal testen.
 Dabei erfolgt eine Ausgabe in Listen Vorschau.

 Danach kannst du die Zeile ausführen welche mit Export-CSV endet. Hier wird das ganze dann
 in eine CSV-Datei exportiert. Den Dateinamen und Export-Pfad findest du am Ende der Zeile.
 In diesem Script ist dies C:\EulachtalMailboxes.csv .
 
 Bei Fragen wende dich an die IT-Abteilung 
 

#>


Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


Get-Mailbox -ResultSize Unlimited | Select DisplayName,UserPrincipalName,RecipientTypeDetails,TotalItemSize,@{Name='Licenses';Expression={(Get-MsolUser -UserPrincipalName $_.UserPrincipalName | Select -ExpandProperty Licenses).AccountSkuID}} | Out-GridView


Get-Mailbox -ResultSize Unlimited | Select DisplayName,UserPrincipalName,RecipientTypeDetails,TotalItemSize,@{Name='Licenses';Expression={(Get-MsolUser -UserPrincipalName $_.UserPrincipalName | Select -ExpandProperty Licenses).AccountSkuID}} | Export-CSV -NoTypeInformation C:\EulachtalMailboxes.csv -Delimiter ";" -Encoding UTF8

