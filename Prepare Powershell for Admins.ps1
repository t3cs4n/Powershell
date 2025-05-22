# Prepare Powershell for admins


# Installiere das Microsoft Graph PowerShell SDK

Install-Module -Name Microsoft.Graph -Force -AllowClobber

# Aktualisiere PowerShellGet

Install-Module -Name PowerShellGet -Force -AllowClobber

# MSOnline-Modul

Install-Module -Name MSOnline -Force -AllowClobber -Scope AllUsers

# Installieren Sie das Active Directory-Modul

Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0

# Installiere das Exchange Online PowerShell-Modul

Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber



