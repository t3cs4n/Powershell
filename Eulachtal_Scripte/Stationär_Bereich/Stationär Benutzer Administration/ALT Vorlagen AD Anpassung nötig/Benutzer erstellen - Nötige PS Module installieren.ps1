# Spitex Benutzer erstellen - Nötige PS Module

# Erst mal muüssen die RSAT Tools installiert werden

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Aktuellen Installations-Status der RSAT-Tools anzeigen über die PowerShell

Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State

# Die Installation der RSAT-Tools über PowerShell starten Sie über die folgende Befehlszeile

Get-WindowsCapability -Name RSAT* -Online | ForEach-Object { Add-WindowsCapability -Online -Name $_.Name }



Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers

Install-Module -Name AzureAD -Force -AllowClobber -Scope AllUsers

Install-Module -Name Microsoft.Graph -Force -AllowClobber -Scope AllUsers

Install-Module -Name MSOnline -Force -AllowClobber -Scope AllUsers


