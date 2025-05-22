<# 

 Mit diesem Script kannst du die Profilbilder der Azure und Exchange Benutzer aktualisieren.
 
 Lege die Bilder dazu mit der Bezeichnung Vorname_Nachname.jpg in folgendem Pfad ab : X:\03_IT\02. Mitarbeiter Fotos\Informatik_Eulachtal.jpg .
 
 Passe vor dem ausführen jeweils den Usernamen und den Namen des Bildes am Schluss des Pfades im Befehl an (siehe nächste Zeile).

 In der Zeile 16 siehst du den Befehl als Beispiel. In dem Fall ist informatik der Benutzernamen und Informatik_Eulachtal.jpg der Namen des Bildes.

 Führe jede Zeile des Scripts einzeln durch. Bestätige den Dialog am Schluss mit JA.  
 
 Solltest du weitere Fragen haben, zögere nicht sie zu stellen, wir helfen gerne. LG Informatik Eulachtal.


 Set-UserPhoto informatik -PictureData ([System.IO.File]::ReadAllBytes("X:\03_IT\02. Mitarbeiter Fotos\Informatik_Eulachtal.jpg"))

#>



Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline -UserPrincipalName admin@pflegeeulachtal.onmicrosoft.com


Set-UserPhoto miguel.santiago -PictureData ([System.IO.File]::ReadAllBytes("X:\03_IT\02. Mitarbeiter Fotos\miguel_santiago.png"))
