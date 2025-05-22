<#

 Zertifikate via Powershell erstellen, verwalten, etc.

 Source : https://www.windowspro.de/script/new-selfsignedcertificate-selbstsignierte-zertifikate-ausstellen-powershell


#>


<# Erstellen des Zertifikats. Gültigkeit 5 Jahre #>

New-SelfSignedCertificate -DnsName remotedesk.eulachtal.ch `
>> -CertStoreLocation Cert:\LocalMachine\My -NotAfter (Get-Date).AddYears(5)


<# 

Zertifikat exportieren, mit Password. Dieses wird vorher noch in sicheren String verpackt. 
Passe wenn nötig den Wert für Thumbprint an. Dazu musst du dir das Zertifikat anzeigen lassen,
dort wird der Wert Thumbprint angezeigt.

#>

$mypwd = ConvertTo-SecureString -String "!*RDSDesk@Eulachtal*!" -Force -AsPlainText

Get-ChildItem -Path Cert:\LocalMachine\My\ | where{$_.Thumbprint -eq "79F06D93AD632B085DB44971A6E4324299BFE268"} | Export-PfxCertificate -FilePath C:\Temp\mypfx.pfx -Password $mypwd 