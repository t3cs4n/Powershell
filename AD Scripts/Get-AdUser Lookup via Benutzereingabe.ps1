<#

Autor : Miguel Santiago

Dieses Script kannst du nutzen um Benutzer aus der AD auslesen und (gewünschte) Eigenschaften
zu exportieren (in diesem Bsp: name und samaccountname).

Der Name des Benutzers den du suchen möchtest, wird beim ausführen abgefragt. In diesem Beispiel
fragt er nach dem Vornamen. Dies kann ebenfalls auch Wunsch angepasst werden.


#>


$NameFirst = $(Write-Host -NoNewLine) + $(Write-Host 'Gib den Vornamen des Benutzers ein: ' -ForegroundColor Green -NoNewLine; Read-Host)
$NameLookup = "*$NameFirst*"

    #Get-ADuser Lookup Based on Defined Variableuserprincis
    Get-ADuser -Filter {name -like $NameLookup} -Properties * | Select-Object name, samaccountname | Out-GridView


<#

$NameFirst = $(Write-Host -NoNewLine) + $(Write-Host 'Gib den Vornamen des Benutzers ein: ' -ForegroundColor Green -NoNewLine; Read-Host)
$NameLookup = "*$NameFirst*"

    #Get-ADuser Lookup Based on Defined Variableuserprincis
    Get-ADuser -Filter {name -like $NameLookup} -Properties * | Select-Object name, samaccountname | Export-Csv -Path \\netapp01\daten\03_IT\000._AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\Email-Adressen_Mitarbeiter_Eulachtal.csv -Encoding UTF8

#>