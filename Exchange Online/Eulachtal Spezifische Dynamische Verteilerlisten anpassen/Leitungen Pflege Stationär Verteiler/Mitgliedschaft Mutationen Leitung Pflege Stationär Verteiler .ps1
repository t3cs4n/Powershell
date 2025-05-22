<#

Mit diesem Script kannst du die Benutzerdefinierten Attribute (für Dynamische Verteilergruppen setzten).
Diese werden im AD Users Snap in wie folgt genannt "extensionAttribute 1-15"
Wir setzten das extensionAttribute 1 um Dynamische Verteilergruppen zu steuern.
Dort erfassen wir den Namen der Verteilergruppe bei den Benutzerkonten, so werden diese aut. der Dynamischen Verteilergruppe zugewiesen oder eben nicht.

#>


# Setzen des Benutzerdefinierten Attributs 1 auf den Wert "Leitung Pflege Stationär" für mehrere Benutzer  >>> Powershell Befehl Zeile 16

# Setzen des Benutzerdefinierten Attributs 1 auf den Wert "Leitung Pflege Stationär" für einen Benutzer  >>> Powershell Befehl Zeile 18


'hema','goyu','yaza','bosu','javi','sico','rami','scsa','prsu','heva' | ForEach-Object {Set-AdUser -Identity $_ -Replace @{extensionAttribute1="Leitung Pflege Stationär"}}

'heva' | ForEach-Object {Set-AdUser -Identity $_ -Replace @{extensionAttribute1="Leitung Pflege Stationär"}}



# Löschen des Werts Benutzerdefiniertes Attribut 1 für mehrere Benutzer  >>> Powershell Befehl Zeile 27

# Löschen des Werts Benutzerdefiniertes Attribut 1 für einen Benutzer  >>> Powershell Befehl Zeile 29


'miguel.santiago','redo' | ForEach-Object {Set-AdUser -Identity $_ -Clear "extensionattribute1"}

'heva' | ForEach-Object {Set-AdUser -Identity $_ -Clear "extensionattribute1"}

<# 

Führe danach den Teil "Aktualisieren der Mitgliedschaft der Dynamischen Verteilergruppe Kader Pflege Stationär" 
aus. Führe immer zeile für Zeile aus. Danach dann noch den Delta Sync Teil. Nach dem Sync sollte der Benutzer Mitglied in der
gewünschten Dynamischen Verteiler Gruppe sein. Dies kontrollierst du am besten in Microsoft 365 in dem du dir die Mitglieder
der Dynmischen Gruppe ansiehst.

#>


# Aktualisieren der Mitgliedschaft der Dynamischen Verteilergruppe Kader Pflege Stationär 


# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName admin@pflegeeulachtal.onmicrosoft.com


<# Das Aktualisieren der Mitglieder einer Dynamischen Verteilerliste erzwingen. 
   Um eine andere Dynamische Verteilerliste zu aktualisieren als die unten verwendete, 
   ersetze einfach die Mailadresse mit derjenigen der zu aktualisierenden Verteilerliste.
  
   Nach dem Ausführen des Befehles kommt folgende Meldung:

   WARNUNG: Der Befehl wurde erfolgreich abgeschlossen, 
            es wurden jedoch keine Einstellungen von 
            'Kader Pflege Stationär' geändert.

   Diese kannst du ignorieren, sie dient ist lediglich zur Info.

   MERKE: Zwischen zwei erzwungenen Aktualisierungen, müssen mindestens 60 Minuten vergangen sein.
          Ohne Befehl, werden Dynamische Verteilerlisten alle 24h aktualisiert. 
#>
  

Set-DynamicDistributionGroup -Identity leitung.pflege.stationaer@eulachtal.ch -ForceMembershipRefresh


<# 

Nun fehlt noch der Delta Sync um die Änderungen in die Azure Active Directory zu übertragen.Danach kannst du nach 
ein paar Minuten auf Microsoft 365 kontrollieren, ob der hinzugefügte Benutzer bei den Mitgliedern des gewünschten 
Dynamischen Verteilers (in diesem Fall Kader Pflege Stationär) aufgegührt ist.

#>

Start-ADSyncSyncCycle -PolicyType Delta