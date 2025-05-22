<# 

 Install Microsoft Graph PowerShell module

 Quelle : https://www.alitajran.com/install-microsoft-graph-powershell/  

#>

Install-Module Microsoft.Graph -Force

Install-Module Microsoft.Graph.Beta -AllowClobber -Force

Connect-MgGraph -Scopes 'User.Read.All'