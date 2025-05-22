# -----------------------------------------
# PowerShell GUI Tool zum Zurücksetzen von AD-Passwörtern und Entsperren gesperrter Benutzer
# UTF-8-fähig, ohne erzwungene Rechte-Elevation.
# -----------------------------------------

# Zeichencodierung auf UTF-8 setzen (für Windows PowerShell 5.1 relevant)
[System.Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Direktes Initialisieren der Variablen
$SearchBases = @("OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh")
$LogFilePath = "C:\Logs\ADPasswordResets.log"

# 1) Windows Forms laden
Add-Type -AssemblyName System.Windows.Forms

# 2) Prüfen, ob das Active Directory Modul installiert ist
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    [System.Windows.Forms.MessageBox]::Show(
        "Das Active Directory-Modul ist nicht installiert. Bitte installiere die RSAT-AD-Tools.",
        "Fehler",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    return
}

Import-Module ActiveDirectory -ErrorAction Stop

# 3) Funktion für Logging
function Write-Log {
    param (
        [string]$Message,
        [string]$LogFile = $LogFilePath
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $runUser   = $env:USERNAME
    $logEntry  = "$timestamp [$runUser] $Message"
    try {
        Add-Content -Path $LogFile -Value $logEntry
    } catch {
        Write-Host "Fehler beim Schreiben ins Logfile: $_"
    }
}

# 4) Optional: Funktion zur Passwort-Komplexitätsprüfung
function Test-PasswordComplexity {
    param ([SecureString]$Password)

    $minLength       = 8
    $requiresUpper   = $true
    $requiresLower   = $true
    $requiresDigit   = $true
    $requiresSpecial = $true

    if ($Password.Length -lt $minLength) {
        return "Das Passwort muss mindestens $minLength Zeichen enthalten."
    }
    if ($requiresUpper -and $Password -notmatch '[A-Z]') {
        return "Das Passwort muss mindestens einen Großbuchstaben enthalten."
    }
    if ($requiresLower -and $Password -notmatch '[a-z]') {
        return "Das Passwort muss mindestens einen Kleinbuchstaben enthalten."
    }
    if ($requiresDigit -and $Password -notmatch '\d') {
        return "Das Passwort muss mindestens eine Ziffer enthalten."
    }
    if ($requiresSpecial -and $Password -notmatch '[^a-zA-Z0-9]') {
        return "Das Passwort muss mindestens ein Sonderzeichen enthalten."
    }

    return $true
}

# 5) Formular vorbereiten
$form               = New-Object System.Windows.Forms.Form
$form.Text          = "Passwort zurücksetzen & Benutzer entsperren (AD)"
$form.Size          = New-Object System.Drawing.Size(450, 370)
$form.StartPosition = "CenterScreen"

# Label für Benutzer
$lblUser               = New-Object System.Windows.Forms.Label
$lblUser.Text          = "Benutzer auswählen:"
$lblUser.AutoSize      = $true
$lblUser.Location      = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($lblUser)

# Combobox für Benutzer
$comboBoxUsers         = New-Object System.Windows.Forms.ComboBox
$comboBoxUsers.DropDownStyle = "DropDownList"
$comboBoxUsers.Size     = New-Object System.Drawing.Size(200, 20)
$comboBoxUsers.Location = New-Object System.Drawing.Point(180, 20)
$form.Controls.Add($comboBoxUsers)

# Label und Textbox für neues Passwort
$lblPassword           = New-Object System.Windows.Forms.Label
$lblPassword.Text      = "Neues Passwort:"
$lblPassword.AutoSize  = $true
$lblPassword.Location  = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($lblPassword)

$txtPassword           = New-Object System.Windows.Forms.TextBox
$txtPassword.Size      = New-Object System.Drawing.Size(200, 20)
$txtPassword.Location  = New-Object System.Drawing.Point(180, 60)
$txtPassword.UseSystemPasswordChar = $true
$form.Controls.Add($txtPassword)

# Checkbox zum Erzwingen der Passwortänderung
$chkChangeAtNextLogon  = New-Object System.Windows.Forms.CheckBox
$chkChangeAtNextLogon.Text = "Änderung bei nächster Anmeldung erzwingen"
$chkChangeAtNextLogon.AutoSize = $true
$chkChangeAtNextLogon.Location = New-Object System.Drawing.Point(20, 100)
$form.Controls.Add($chkChangeAtNextLogon)

# Checkbox zum Entsperren eines gesperrten Benutzers
$chkUnlockAccount = New-Object System.Windows.Forms.CheckBox
$chkUnlockAccount.Text = "Benutzer entsperren (falls gesperrt)"
$chkUnlockAccount.AutoSize = $true
$chkUnlockAccount.Location = New-Object System.Drawing.Point(20, 130)
$form.Controls.Add($chkUnlockAccount)

# Button zum Zurücksetzen
$btnReset              = New-Object System.Windows.Forms.Button
$btnReset.Text         = "Passwort zurücksetzen"
$btnReset.Size         = New-Object System.Drawing.Size(150, 30)
$btnReset.Location     = New-Object System.Drawing.Point(140, 170)
$form.Controls.Add($btnReset)

# 6) Benutzer aus angegebenen OUs laden
$allUsers = @()
try {
    foreach ($base in $SearchBases) {
        $tempUsers = Get-ADUser -Filter * -SearchBase $base -SearchScope Subtree -Properties SamAccountName, Name 2>$null
        if ($tempUsers) {
            $allUsers += $tempUsers
        }
    }

    $uniqueUsers = $allUsers | Sort-Object -Property Name -Unique

    foreach ($user in $uniqueUsers) {
        [void] $comboBoxUsers.Items.Add($user.Name)
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show(
        "Fehler beim Laden der Benutzer: $_",
        "Fehler",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    Write-Log "Fehler beim Laden der Benutzer: $_"
}

# 7) Passwort-zurücksetzen-Logik inkl. Entsperren
$btnReset.Add_Click({
    $selectedUserName = $comboBoxUsers.SelectedItem
    $newPassword      = $txtPassword.Text

    if (-not $selectedUserName -or [string]::IsNullOrWhiteSpace($newPassword)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Bitte einen Benutzer auswählen und ein neues Passwort eingeben.",
            "Fehler",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        return
    }

    $complexityCheck = Test-PasswordComplexity -Password $newPassword
    if ($complexityCheck -ne $true) {
        [System.Windows.Forms.MessageBox]::Show(
            $complexityCheck,
            "Passwortfehler",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        return
    }

    try {
        $adUser = Get-ADUser -Filter "Name -eq '$selectedUserName'" -ErrorAction Stop
        $securePass = ConvertTo-SecureString -String $newPassword -AsPlainText -Force
        Set-ADAccountPassword -Identity $adUser.SamAccountName -Reset -NewPassword $securePass -ErrorAction Stop

        if ($chkChangeAtNextLogon.Checked) {
            Set-ADUser -Identity $adUser.SamAccountName -ChangePasswordAtLogon $true
        }

        if ($chkUnlockAccount.Checked) {
            Unlock-ADAccount -Identity $adUser.SamAccountName -ErrorAction Stop
        }

        [System.Windows.Forms.MessageBox]::Show("Passwort erfolgreich geändert!", "Erfolg", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $txtPassword.Clear()
        $comboBoxUsers.SelectedIndex = -1

    } catch {
        [System.Windows.Forms.MessageBox]::Show("Fehler: $_", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# 8) Formular anzeigen
[void] $form.ShowDialog()