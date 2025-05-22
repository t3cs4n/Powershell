<#

Autor : Miguel Santiago

Mit diesem Script kannst du die Mitgliedschaft von dynamischen Verteilergruppen aktualisieren.
Bei Fragen wende dich an die IT Abteilung.

#>


# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


<# Das Aktualisieren der Mitglieder einer Dynamischen Verteilerliste erzwingen. 
   Um eine andere Dynamische Verteilerliste zu aktualisieren als die unten verwendete, 
   ersetze einfach die Mailadresse mit derjenigen der zu aktualisierenden Verteilerliste.
  
   Nach dem Ausführen des Befehles kommt folgende Meldung:

   WARNUNG: Der Befehl wurde erfolgreich abgeschlossen, es wurden jedoch keine Einstellungen von 'Kader Pflege Stationär' geändert.

   Diese kannst du ignorieren, sie dient lediglich zur Info.

   MERKE: Zwischen zwei erzwungenen Aktualisierungen, müssen mindestens 60 Minuten vergangen sein.
          Ohne Befehl, werden Dynamische Verteilerlisten alle 24h aktualisiert. 
     
  
#>
  


Set-DynamicDistributionGroup -Identity kader_pflege_stationaer@eulachtal.ch -ForceMembershipRefresh
 
