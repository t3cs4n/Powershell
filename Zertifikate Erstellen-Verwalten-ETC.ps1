<#

 Zertifikate via Powershell erstellen, verwalten, etc.

 Source : https://www.windowspro.de/script/new-selfsignedcertificate-selbstsignierte-zertifikate-ausstellen-powershell


#>


<# Erstellen des Zertifikats. Gültigkeit 5 Jahre #>

$certname = "{certificateName}"    ## Replace {certificateName}
New-SelfSignedCertificate -Subject "CN=$certname" -DnsName "carecoach.eulachtal.ch" -CertStoreLocation "Cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears(10) -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256




<# 

Zertifikat exportieren, mit Password. Dieses wird vorher noch in sicheren String verpackt. 
Passe wenn nötig den Wert für Thumbprint an. Dazu musst du dir das Zertifikat anzeigen lassen,
dort wird der Wert Thumbprint angezeigt.

#>

$mypwd = ConvertTo-SecureString -String "!*RDSDesk@Eulachtal*!" -Force -AsPlainText

Get-ChildItem -Path Cert:\LocalMachine\My\ | Where-Object{$_.Thumbprint -eq "A5DD78441A71B701FB6913E63965863BC3131F5E"} | Export-PfxCertificate -FilePath C:\homeoffice.pfx -Password $mypwd 


