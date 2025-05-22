<#

 Mit diesem Script kannst du alle nötigen Programme die 
 noch nicht auf dem Computer sind automatisiert installieren.

 Die letzte Zeile (winget upgrade ....) aktualisiert alle mit Winget installierten Programme. 

 Bei Fragen wende dich an die IT Abteilung

#>


# winget install --id=Google.Chrome  -e 
winget install --id=Mozilla.Firefox  -e
winget install --id=geeksoftwareGmbH.PDF24Creator  -e

winget upgrade --all --silent --accept-package-agreements --accept-source-agreements --force

