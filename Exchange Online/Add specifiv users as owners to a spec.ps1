# Add specifiv users as owners to a specific distribution list

# Verbinde dich mit Exchange Online
Connect-ExchangeOnline -UserPrincipalName informatik@eulachtal.ch

# Definiere die E-Mail-Adresse der Verteilerliste
$distributionGroupEmail = "todesfall@eulachtal.ch"

# Definiere die E-Mail-Adressen der Benutzer, die als Besitzer hinzugefügt werden sollen
$newOwners = @(
    "informatik@eulachtal.ch",
    "anita.hohler@eulachtal.ch",
    "Monika.Froehlich@eulachtal.ch",
    "Fabienne.Buff@eulachtal.ch",
    "Bernadette.Widmer@eulachtal.ch"
)


# Hole die aktuellen Besitzer der Verteilerliste
try {
    $currentOwners = (Get-DistributionGroup -Identity $distributionGroupEmail).ManagedBy
    Write-Host "Aktuelle Besitzer der Verteilerliste $($distributionGroupEmail): $($currentOwners -join ', ')" -ForegroundColor Cyan
} catch {
    Write-Host "Fehler beim Abrufen der aktuellen Besitzer der Verteilerliste $($distributionGroupEmail): $_" -ForegroundColor Red
    exit
}

# Konvertiere die aktuellen Besitzer in E-Mail-Adressen
$currentOwnerEmails = $currentOwners | ForEach-Object {
    (Get-Recipient -Identity $_).PrimarySmtpAddress
}

# Filtere die neuen Besitzer, um Duplikate zu vermeiden
$updatedOwners = $currentOwners + @($newOwners | Where-Object { $currentOwnerEmails -notcontains $_ })

# Aktualisiere die Verteilerliste mit den neuen Besitzern
try {
    Set-DistributionGroup -Identity $distributionGroupEmail -ManagedBy $updatedOwners
    Write-Host "Die Besitzer der Verteilerliste $($distributionGroupEmail) wurden erfolgreich aktualisiert." -ForegroundColor Green
} catch {
    Write-Host "Fehler beim Aktualisieren der Besitzer der Verteilerliste $($distributionGroupEmail): $_" -ForegroundColor Red
}

# Trenne die Verbindung zu Exchange Online
Disconnect-ExchangeOnline -Confirm:$false