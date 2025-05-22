# List Primary and Alias Adresses starting by Primary. Users in OU

# Definieren Sie die OU, aus der die Benutzer abgerufen werden sollen
$OU = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Holen Sie sich alle Benutzer aus der angegebenen OU
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties ProxyAddresses, mail, GivenName, Surname

# Initialisieren Sie eine Liste, um die Ergebnisse zu speichern
$Results = @()

# Durchlaufen Sie jeden Benutzer und erstellen Sie die gewünschte Ausgabe
foreach ($User in $Users) {
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

    # Sortieren Sie die Adressen, sodass die primäre SMTP-Adresse zuerst kommt
    $PrimarySMTP = $User.mail # Primäre SMTP-Adresse
    $OtherSMTP = $EmailAddresses | Where-Object { $_ -ne $PrimarySMTP }

    # Erstellen Sie ein benutzerdefiniertes Objekt für die Ausgabe
    $UserOutput = [PSCustomObject]@{
        Name         = "$($User.GivenName) $($User.Surname)" # Vor- und Nachname
        PrimarySMTP  = $PrimarySMTP # Primäre SMTP-Adresse
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
$Results | Out-GridView -Title "E-Mail-Adressen der Benutzer"