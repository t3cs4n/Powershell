# Ersetze Umlaute im UPN


# Definieren Sie die OU, aus der die Benutzer abgerufen werden sollen

$OU = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Funktion zum Ersetzen von Umlauten (nur Kleinbuchstaben)
function Replace-Umlauts {
    param (
        [string]$InputString
    )
    # Hash-Tabelle für Kleinbuchstaben
    $umlautMap = @{
        'ä' = 'ae'
        'ö' = 'oe'
        'ü' = 'ue'
        'ß' = 'ss'
    }

    # Ersetze Kleinbuchstaben
    foreach ($umlaut in $umlautMap.Keys) {
        $InputString = $InputString -replace [regex]::Escape($umlaut), $umlautMap[$umlaut]
    }

    return $InputString
}

# Holen Sie sich alle Benutzer aus der angegebenen OU
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties ProxyAddresses, mail, GivenName, Surname, UserPrincipalName

# Initialisieren Sie eine Liste, um die Ergebnisse zu speichern
$Results = @()

# Durchlaufen Sie jeden Benutzer und erstellen Sie die gewünschte Ausgabe
foreach ($User in $Users) {
    # UPN des Benutzers
    $UPN = $User.UserPrincipalName

    # Umlaute im UPN ersetzen (falls notwendig)
    $NewUPN = Replace-Umlauts -InputString $UPN

    # Überprüfen, ob der UPN geändert wurde
    if ($UPN -ne $NewUPN) {
        # Aktualisieren Sie den UPN im Active Directory
        try {
            Set-ADUser -Identity $User -UserPrincipalName $NewUPN -ErrorAction Stop
            Write-Output "UPN für $($User.SamAccountName) aktualisiert: $UPN -> $NewUPN"
        } catch {
            Write-Output "Fehler beim Aktualisieren des UPN für $($User.SamAccountName): $_"
        }
    }

    # Initialisieren Sie eine leere Liste für die E-Mail-Adressen
    $EmailAddresses = @()

    # Durchlaufen Sie die ProxyAddresses des Benutzers
    foreach ($ProxyAddress in $User.ProxyAddresses) {
        # Überprüfen Sie, ob die Adresse eine SMTP-Adresse ist
        if ($ProxyAddress -like "SMTP:*") {
            # Entfernen Sie das "SMTP:"-Präfix und fügen Sie die Adresse zur Liste hinzu
            $EmailAddresses += $ProxyAddress.Substring(5)
        }
    }

    # Primäre SMTP-Adresse
    $PrimarySMTP = $User.mail

    # Zusätzliche SMTP-Aliase
    $OtherSMTP = $EmailAddresses | Where-Object { $_ -ne $User.mail }

    # Erstellen Sie ein benutzerdefiniertes Objekt für die Ausgabe
    $UserOutput = [PSCustomObject]@{
        Name         = "$($User.GivenName) $($User.Surname)" # Vor- und Nachname (unverändert)
        UPN          = $NewUPN # Neuer UPN (Umlaute ersetzt)
        PrimarySMTP  = $PrimarySMTP # Primäre SMTP-Adresse (unverändert)
    }

    # Fügen Sie die zusätzlichen SMTP-Aliase als separate Eigenschaften hinzu
    $Index = 1
    foreach ($Alias in $OtherSMTP) {
        $UserOutput | Add-Member -MemberType NoteProperty -Name "Alias$Index" -Value $Alias
        $Index++
    }

    # Fügen Sie das benutzerdefinierte Objekt zur Ergebnisliste hinzu
    $Results += $UserOutput
}

# Zeigen Sie die Ergebnisse in einem GridView an
$Results | Out-GridView -Title "E-Mail-Adressen der Benutzer (Umlaute im UPN ersetzt)"