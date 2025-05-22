# Spitex Benutzer löschen

# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# Importiere das Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms

# Definiere die OU, aus der die Benutzer gelöscht werden sollen
$targetOU = "OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Erstelle ein Windows Forms-Fenster
$form = New-Object System.Windows.Forms.Form
$form.Text = "Benutzer löschen"
$form.Size = New-Object System.Drawing.Size(400, 200)

# Erstelle ein Label für die Eingabeaufforderung
$label = New-Object System.Windows.Forms.Label
$label.Text = "Geben Sie die Email des zu löschenden Benutzers ein:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10, 10)

# Erstelle ein TextBox-Feld für die UPN-Eingabe
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(360, 20)
$textBox.Location = New-Object System.Drawing.Point(10, 40)

# Erstelle einen Löschen-Button
$deleteButton = New-Object System.Windows.Forms.Button
$deleteButton.Text = "Löschen"
$deleteButton.Size = New-Object System.Drawing.Size(100, 30)
$deleteButton.Location = New-Object System.Drawing.Point(10, 80)
$deleteButton.Add_Click({
    # Hole den eingegebenen UPN
    $upn = $textBox.Text.Trim()

    # Überprüfe, ob ein UPN eingegeben wurde
    if ([string]::IsNullOrEmpty($upn)) {
        [System.Windows.Forms.MessageBox]::Show("Bitte geben Sie einen UPN ein.", "Fehler", "OK", "Error")
        return
    }

    # Überprüfe, ob der Benutzer in der angegebenen OU existiert
    $user = Get-ADUser -Filter { UserPrincipalName -eq $upn } -SearchBase $targetOU -ErrorAction SilentlyContinue
    if (-not $user) {
        [System.Windows.Forms.MessageBox]::Show("Benutzer '$upn' wurde in der OU '$targetOU' nicht gefunden.", "Fehler", "OK", "Error")
        return
    }

    # Bestätige die Löschung
    $confirmation = [System.Windows.Forms.MessageBox]::Show("Möchten Sie den Benutzer '$upn' wirklich löschen?", "Bestätigen", "YesNo", "Question")
    if ($confirmation -eq "No") {
        return
    }

    # Lösche den Benutzer
    try {
        Remove-ADUser -Identity $user -Confirm:$false -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("Benutzer '$upn' wurde erfolgreich gelöscht.", "Erfolg", "OK", "Information")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Fehler beim Löschen des Benutzers '$upn': $_", "Fehler", "OK", "Error")
    }
})

# Füge die Steuerelemente zum Fenster hinzu
$form.Controls.Add($label)
$form.Controls.Add($textBox)
$form.Controls.Add($deleteButton)

# Zeige das Fenster an
$form.ShowDialog()

pause