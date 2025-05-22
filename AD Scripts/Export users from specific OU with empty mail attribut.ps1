<#

Benutzer einer bestimmten OU deren Mail Attribut Wert leer ist (kann auch an andere Attribute angepasst werden),
zu CSV exportieren.


#>


$OU = 'OU=Benutzer_ALLE,OU=Benutzer,OU=EULACHTAL,DC=EULACHTAL,DC=ZH'


Get-ADUser -filter "enabled -eq '$true' -and mail -notlike '*'" -SearchBase $OU -Properties ProxyAddresses | Select-Object Name, UserPrincipalName, Mail, ProxyAddresses | Out-GridView


Get-ADUser -filter "enabled -eq '$true' -and mail -notlike '*'" -SearchBase $OU -Properties * | Where-Object { $_.ProxyAddresses -ne $null } | Select-Object Name, UserPrincipalName, Mail, @{name="proxyAddresses"; expression={$_.proxyAddresses -join ";"}} | Out-GridView


Get-ADUser -filter * "enabled -eq '$true' -and mail -notlike '*'" -SearchBase $OU -Properties ProxyAddresses | Where-Object { $_.ProxyAddresses -ne $null } | Select-Object Name, UserPrincipalName, Mail, ProxyAddresses | Export-Csv -Path \\netapp01\daten\03_IT\000.__AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\CSV\MAIL_Attribut_LeerNEU.csv -NoTypeInformation -Encoding UTF8


Get-ADUser -filter "enabled -eq '$true' -and mail -notlike '*'" -SearchBase $OU -Properties * | Where-Object { $_.ProxyAddresses -ne $null } | Select-Object Name, UserPrincipalName, Mail, @{name="proxyAddresses"; expression={$_.proxyAddresses -join ";"}} | Export-Csv -Path \\netapp01\daten\03_IT\000.__AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\CSV\MAIL_Attribut_LeerNEU.csv -NoTypeInformation -Encoding UTF8



# | Export-Csv -Path \\netapp01\daten\03_IT\000.__AADS_UND_ADS_EXPORTE_CLEANING__\SPITEX\AAD_UND_AD_Exporte\CSV\TestMail1.csv -NoTypeInformation -Encoding UTF8






Get-ADUser -Filter * -SearchBase ‘ou=testou,dc=iammred,dc=net’ -Properties proxyaddresses | select name, @{name="proxyAddresses"; expression={$_.proxyAddresses -join ";"}} | Export-Csv -Path c:\fso\proxyaddresses.csv –NoTypeInformation




