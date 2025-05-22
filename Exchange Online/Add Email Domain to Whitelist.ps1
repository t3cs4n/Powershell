Connect-ExchangeOnline -UserPrincipalName informatik@eulachtal.ch

# Transportregel erstellen
New-TransportRule -Name "Whitelist Beispiel Domain" -SenderDomainIs "dearemployee.de" -SetSCL -1