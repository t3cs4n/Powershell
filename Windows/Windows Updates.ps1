<#

Mit diesem Script kannst du Windows Updates per Windows Script erledigen.

Führe Zeile per Zeile aus.

Bei Fragen wende dich an die IT Abteilung.


Erweiterte Befehle und Tools

WSUS mit der PowerShell verwalten
Auch der Serverdienst für die Verwaltung von Updates lässt sich in der PowerShell steuern. Hier stehen in Windows Server 2019 und 2022 verschiedene Cmdlets zur Verfügung.

Wer WSUS in der PowerShell verwalten will, kann sich mit dem Befehl get-command -module updateservices alle Cmdlets anzeigen lassen, mit denen man Windows Server Update Services verwalten kann:

Add-WsusComputer – fügt einen PC einer bestimmten WSUS-Gruppe hinzu.
Approve-WsusUpdate – gibt Updates frei.
Deny-WsusUpdate – verweigert Updates.
Get-WsusClassification – zeigt alle verfügbaren Klassifikationen an.
Get-WsusComputer – zeigt WSUS-Clients/ und -Computer an. Hier sind die angebundenen Geräte, deren Betriebssystem und der Zeitpunkt der letzten Statusübermittlung zu sehen.
Get-WsusProduct – zeigt eine Liste aller Programme an, für die der Server Patches bereithält.
Get-WsusServer – zeigt alle WSUS-Server im Netzwerk an.
Get-WsusUpdate – zeigt Informationen zu Updates an.
Invoke-WsusServerCleanup – startet den Bereinigungsvorgang.
Set-WsusClassification – fügt Klassifikationen zu WSUS hinzu.
Set-WsusProduct – fügt Produkte zu WSUS hinzu.
Set-WsusServerSynchronization – steuert die WSUS-Synchronisierung.
Windows-Updates in der Eingabeaufforderung und PowerShell steuern
Ein weiteres wichtiges Werkzeug, um Updates per Skript zu installieren, ist das Befehlszeilen-Tool wusa.exe. Die Syntax dazu ist:

Wusa.exe <MSU-Datei des Patches> /quiet /norestart


#>


Install-Module -Name PSWindowsUpdate -Force


# Get-Command -Module PSWindowsUpdate


# Get-WindowsUpdate -MicrosoftUpdate -Verbose


# Download-WindowsUpdate -MicrosoftUpdate -AcceptAll


Install-WindowsUpdate -MicrosoftUpdate -AcceptAll






<#


 Get-PSRepository


 Register-PSRepository -Default


 Get-PackageProvider -ListAvailable


 Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201


 [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Register-PSRepository -Default


Set-PSRepository -Name PSGallery -InstallationPolicy Trusted


 Get-Module PowerShellGet -ListAvailable
  

 Find-Module PowershellGet
  

 Install-Module PowershellGet -Force


 #>
