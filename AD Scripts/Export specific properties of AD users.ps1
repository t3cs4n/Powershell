<#Mit diesem Script lassen sich die Benutzer aus der angegebenen OU exportieren (Grid oder CSV).


  Führe als erstes die Zeile die mit $OU beginnt aus. Anhand derer setzt du die OU aus welcher exportiert wird. 
  Passe die Zeile bei Bedarf an.


  Es werden die Angaben welche bei Properties angegeben werden exportiert. Mit dem Select Parameter kann man
  festlegen welche Angaben dann zur Anzeige gewählt werden. 

  Beispiele:


  * = Alles / Siehe Beispiel auf den folgenden Zeile. Dieser String exportiert alle Angaben zeigt aber in der Ausgabe nur die unter Select-Object gewählten Angaben.

    Die Zweite Zeile exportiert alles und zeigt auch alles in der Ausgabe aufgrund des * bei Select-Object

  
  Get-ADUser -Filter * -SearchBase $OU -Properties * | Select-Object DisplayName,SamAccountName,UserPrincipalName | Out-GridView

  Get-ADUser -Filter * -SearchBase $OU -Properties * | * | Out-GridView


  Ob Gridview oder CSV bestimmst du Anhand der Zeile die du ausführst. 
  
  Zeile 35 = Gridview

  Zeile 38 = CSV-Datei / Für den Export zu einer CSV Datei benutzt man den Befehl | Export-Csv gefolgt vom parameter -Path und dann die Pfad und Dateiname c:\AusgabeDatei.csv (siehe Beispiel in der anfangs genannten Zeile)

 #> 

$OU = 'OU=Benutzer_Alle,OU=Benutzer,OU=EULACHTAL,DC=EULACHTAL,DC=ZH'


Get-ADUser -Filter * -SearchBase $OU -Properties DisplayName,SamAccountName,UserPrincipalName | Select-Object DisplayName,SamAccountName,UserPrincipalName | Out-GridView


Get-ADUser -Filter * -SearchBase $OU -Properties DisplayName,SamAccountName,UserPrincipalName | Select-Object DisplayName,SamAccountName,UserPrincipalName | Export-Csv -Path \\netapp01\daten\03_IT\000._AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\AbacusKürzel.csv -Encoding UTF8
