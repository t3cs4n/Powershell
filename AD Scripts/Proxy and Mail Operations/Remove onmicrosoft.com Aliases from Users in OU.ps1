# Remove mail.onmicrosoft.com / onmicrosoft.com Aliases from Users in OU

# Definieren Sie die OU, aus der die Benutzer abgerufen werden sollen
$OU = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Holen Sie sich alle Benutzer aus der angegebenen OU
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties ProxyAddresses, mail

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

    # Kombinieren Sie die primäre SMTP-Adresse mit den anderen Adressen
    $CombinedAddresses = @($PrimarySMTP) + $OtherSMTP

    # Erstellen Sie die Ausgabezeile
    $Output = $CombinedAddresses -join ", "

    # Geben Sie die Ausgabe für den Benutzer aus
    Write-Output "$($User.SamAccountName): $Output"
}