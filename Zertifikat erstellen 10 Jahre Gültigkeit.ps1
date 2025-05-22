<#

  Create and Export Selfsigned Certificate 10 years valid with Password to PFX File
  

#>

# Define validity period (adjust for leap years if necessary)
$tenYears = New-TimeSpan -Days 3650

# Subject name for the certificate (replace with your desired name)
$subjectName = "homeoffice.eulachtal.zh"

# Generate a strong password for the PFX file (store securely)
$password = ConvertTo-SecureString "!homeoffice.Cert.2024!" -AsPlainText -Force

# Create the self-signed certificate
$certificate = New-SelfSignedCertificate -Subject $subjectName -NotAfter (Get-Date).Add($tenYears) -KeyUsage DigitalSignature, KeyEncipherment

# Export the certificate to PFX format
$pfxFilePath = "C:\Zertifikate\homeoffice-cert2024.pfx"  # Replace with your desired path
Export-PfxCertificate -Cert $certificate -FilePath $pfxFilePath -Password $password

Write-Host "Self-signed certificate created and exported to PFX: $pfxFilePath"
