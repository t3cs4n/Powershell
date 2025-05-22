# Benutzern auf Postfächer Delegationsrechte vergeben

<#
.SYNOPSIS
    Postfachberechtigungen mit Modern Authentication
.DESCRIPTION
    Weist "Senden als", "Senden im Auftrag" und "Vollzugriff" für einen Benutzer auf mehrere Postfächer zu
.NOTES
    Version: 1.3
    Autor: Your Name
    Voraussetzung: ExchangeOnlineManagement Modul (V2+)
#>

#requires -Module ExchangeOnlineManagement

function Connect-EXO {
    Write-Host "`n=== Exchange Online Authentifizierung ===" -ForegroundColor Cyan
    Write-Host "Es öffnet sich ein modernes Login-Fenster..." -ForegroundColor Yellow
    
    try {
        # Modern Authentication mit automatischem Token-Handling
        Connect-ExchangeOnline -UserPrincipalName $adminUPN -ShowBanner:$false -ShowProgress:$true
        
        Write-Host "Erfolgreich verbunden!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Fehler bei der Verbindung: $_" -ForegroundColor Red
        return $false
    }
}

function Assign-Permissions {
    param(
        [string[]]$Mailboxes,
        [string]$User
    )

    foreach ($mailbox in $Mailboxes) {
        try {
            Write-Host "`nVerarbeite Postfach: $($mailbox)" -ForegroundColor Cyan
            
            # 1. "Senden als" Berechtigung
            Write-Host "- Weise 'Senden als' zu..." -NoNewline
            Add-RecipientPermission -Identity $mailbox -Trustee $User -AccessRights SendAs -Confirm:$false -ErrorAction Stop
            Write-Host " [OK]" -ForegroundColor Green

            # 2. "Senden im Auftrag"
            Write-Host "- Weise 'Senden im Auftrag' zu..." -NoNewline
            Set-Mailbox -Identity $mailbox -GrantSendOnBehalfTo @{Add=$User} -ErrorAction Stop
            Write-Host " [OK]" -ForegroundColor Green

            # 3. "Vollzugriff"
            Write-Host "- Weise 'Vollzugriff' zu..." -NoNewline
            Add-MailboxPermission -Identity $mailbox -User $User -AccessRights FullAccess -InheritanceType All -ErrorAction Stop
            Write-Host " [OK]" -ForegroundColor Green

            # Berechtigungsbestätigung
            Write-Host ("`nZusammenfassung für {0}:" -f $mailbox) -ForegroundColor Yellow
            Get-RecipientPermission $mailbox | Where-Object {$_.Trustee -eq $User} | Format-Table Identity, Trustee, AccessRights
            Get-Mailbox $mailbox | Select-Object -ExpandProperty GrantSendOnBehalfTo | Where-Object {$_ -match $User}
            Get-MailboxPermission $mailbox | Where-Object {$_.User -like "*$User*" -and -not $_.IsInherited} | Format-Table Identity, User, AccessRights
        }
        catch {
            Write-Host " FEHLER: $_" -ForegroundColor Red
            continue
        }
    }
}

# Hauptprogramm
Clear-Host
Write-Host "=== Exchange Postfachberechtigungs-Tool ===" -ForegroundColor Magenta
Write-Host "Modern Authentication Version`n" -ForegroundColor Cyan

# 1. Admin-Login
do {
    $global:adminUPN = Read-Host "Ihr Admin-UPN (z.B. admin@domain.de)"
} until ($adminUPN -match "@")

if (-not (Connect-EXO)) { exit }

# 2. Berechtigungszuweisung
do {
    Write-Host "`n=== Neue Berechtigungszuweisung ===" -ForegroundColor Yellow
    
    # Postfacheingabe
    $mailboxes = (Read-Host "Postfächer (kommagetrennt, z.B. mailbox1,shared-box,hr@domain.de)").Split(',').Trim() | Where-Object {$_ -ne ""}
    
    # Benutzereingabe
    do {
        $user = Read-Host "Benutzer-UPN (z.B. user@domain.de)"
    } until ($user -match "@")
    
    # Berechtigungen zuweisen
    Assign-Permissions -Mailboxes $mailboxes -User $user

    # Weiterer Durchlauf?
    $continue = Read-Host "`nWeitere Benutzer bearbeiten? (j/n)"
} while ($continue -in @('j','J','y','Y'))

# Aufräumen
Write-Host "`nBeende Session..." -ForegroundColor Cyan
Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
Write-Host "Fertig!`n" -ForegroundColor Green