# Spitex Benutzer erstellen Option mit Auflistung der Gruppen aus bestimmten OUs V3

# Importieren der Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms

# Prüfen, ob das Active Directory-Modul vorhanden ist
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    [System.Windows.Forms.MessageBox]::Show("Das Active Directory-Modul ist nicht installiert. Bitte installieren Sie die RSAT-AD-Tools.", "Fehler", "OK", "Error")
    exit
}

# Ziel-OU für Benutzererstellung
$OU = "OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# OU für lokale Gruppenabruf
$groupOU = "OU=Gruppen_Ambulant,OU=Rechtevergabe_Hybrid,OU=Gruppen,OU=Eulachtal,DC=eulachtal,DC=zh"

# OU für Lizenz Gruppenabruf
$licenseGroupOU = "OU=Gruppen_Lizenzen,OU=Rechtevergabe_Hybrid,OU=Gruppen,OU=Eulachtal,DC=eulachtal,DC=zh"

# Formular erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Neuen AD-Benutzer erstellen"
$form.Size = New-Object System.Drawing.Size(800, 1000)
$form.StartPosition = "CenterScreen"

# Labels und Eingabefelder erstellen
$controls = @()
$labels = "Pre-Windows 2000 Name", "Vorname", "Nachname", "E-Mail-Adresse", "Passwort"
$y = 20
foreach ($label in $labels) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $label
    $lbl.Size = New-Object System.Drawing.Size(250, 20)
    $lbl.Location = New-Object System.Drawing.Point(10, $y)
    $form.Controls.Add($lbl)
    
    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Size = New-Object System.Drawing.Size(200, 20)
    $txt.Location = New-Object System.Drawing.Point(270, $y)
    if ($label -eq "Passwort") {
        $txt.UseSystemPasswordChar = $true  # Passwort verdeckt eingeben
    }
    $form.Controls.Add($txt)
    $controls += $txt

    $y += 40
}

# Dropdown-Menü für Beschreibung erstellen
$lblDescription = New-Object System.Windows.Forms.Label
$lblDescription.Text = "Beschreibung"
$lblDescription.Size = New-Object System.Drawing.Size(250, 20)
$lblDescription.Location = New-Object System.Drawing.Point(10, $y)
$form.Controls.Add($lblDescription)

$comboBoxDescription = New-Object System.Windows.Forms.ComboBox
$comboBoxDescription.Size = New-Object System.Drawing.Size(200, 20)
$comboBoxDescription.Location = New-Object System.Drawing.Point(270, $y)
$comboBoxDescription.Items.AddRange(@("Basic Mobile User", "Basic PC User", "Premium PC User"))
$comboBoxDescription.SelectedIndex = 0  # Standardwert setzen
$form.Controls.Add($comboBoxDescription)

$controls += $comboBoxDescription

$y += 40

# Lokale Gruppenliste hinzufügen
$lblGroupsLocal = New-Object System.Windows.Forms.Label
$lblGroupsLocal.Text = "Ambulant Bereich Gruppen zuweisen"
$lblGroupsLocal.Size = New-Object System.Drawing.Size(250, 20)
$lblGroupsLocal.Location = New-Object System.Drawing.Point(10, $y)
$form.Controls.Add($lblGroupsLocal)

$checkedListBoxLocal = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxLocal.Size = New-Object System.Drawing.Size(250, 150)
$checkedListBoxLocal.Location = New-Object System.Drawing.Point(10, ($y + 30)) 
$form.Controls.Add($checkedListBoxLocal)

# Details-Feld für Gruppennotizen hinzufügen
$lblGroupDetails = New-Object System.Windows.Forms.Label
$lblGroupDetails.Text = "Notizen der ausgewählten Gruppe:"
$lblGroupDetails.Size = New-Object System.Drawing.Size(250, 20)
$lblGroupDetails.Location = New-Object System.Drawing.Point(10, ($y + 190))
$form.Controls.Add($lblGroupDetails)

$txtGroupDetails = New-Object System.Windows.Forms.TextBox
$txtGroupDetails.Multiline = $true
$txtGroupDetails.ScrollBars = "Vertical"
$txtGroupDetails.ReadOnly = $true
$txtGroupDetails.Size = New-Object System.Drawing.Size(250, 100)
$txtGroupDetails.Location = New-Object System.Drawing.Point(10, ($y + 220))
$form.Controls.Add($txtGroupDetails)

# Lizenz Gruppenliste hinzufügen
$lblGroupsLicense = New-Object System.Windows.Forms.Label
$lblGroupsLicense.Text = "Lizenz Gruppen zuweisen"
$lblGroupsLicense.Size = New-Object System.Drawing.Size(250, 20)
$lblGroupsLicense.Location = New-Object System.Drawing.Point(270, $y)
$form.Controls.Add($lblGroupsLicense)

$checkedListBoxLicense = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxLicense.Size = New-Object System.Drawing.Size(250, 150)
$checkedListBoxLicense.Location = New-Object System.Drawing.Point(270, ($y + 30)) 
$form.Controls.Add($checkedListBoxLicense)

# Details-Feld für Lizenz Gruppennotizen hinzufügen (für das rechte Fenster)
$lblLicenseGroupDetails = New-Object System.Windows.Forms.Label
$lblLicenseGroupDetails.Text = "Notizen der ausgewählten Lizenz Gruppe:"
$lblLicenseGroupDetails.Size = New-Object System.Drawing.Size(250, 20)
$lblLicenseGroupDetails.Location = New-Object System.Drawing.Point(270, ($y + 190))
$form.Controls.Add($lblLicenseGroupDetails)

$txtLicenseGroupDetails = New-Object System.Windows.Forms.TextBox
$txtLicenseGroupDetails.Multiline = $true
$txtLicenseGroupDetails.ScrollBars = "Vertical"
$txtLicenseGroupDetails.ReadOnly = $true
$txtLicenseGroupDetails.Size = New-Object System.Drawing.Size(250, 100)
$txtLicenseGroupDetails.Location = New-Object System.Drawing.Point(270, ($y + 220))
$form.Controls.Add($txtLicenseGroupDetails)

# Lokale Gruppen aus der definierten OU laden
try {
    $localGroups = Get-ADGroup -Filter * -SearchBase $groupOU | Select-Object -Property Name
    foreach ($group in $localGroups) {
        $checkedListBoxLocal.Items.Add($group.Name)
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("Fehler beim Laden der lokalen Gruppen aus der Gruppen-OU.", "Fehler", "OK", "Error")
}

# Ereignis: Details der ausgewählten Gruppe anzeigen (linke Gruppen)
$checkedListBoxLocal.Add_SelectedIndexChanged({
    $selectedGroup = $checkedListBoxLocal.SelectedItem
    if ($selectedGroup) {
        try {
            # Nur die Notizen der ausgewählten Gruppe abfragen
            $groupDetails = Get-ADGroup -Identity $selectedGroup -Properties Info
            if ($groupDetails) {
                # Nur die Notizen (Info) anzeigen
                $txtGroupDetails.Text = $groupDetails.Info
            } else {
                $txtGroupDetails.Text = "Keine Notizen verfügbar."
            }
        } catch {
            $txtGroupDetails.Text = "Fehler beim Abrufen der Notizen: $_"
        }
    } else {
        $txtGroupDetails.Text = ""
    }
})

# Lizenz Gruppen aus der definierten OU laden
try {
    $licenseGroups = Get-ADGroup -Filter * -SearchBase $licenseGroupOU | Select-Object -ExpandProperty Name
    foreach ($group in $licenseGroups) {
        $checkedListBoxLicense.Items.Add($group)
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("Fehler beim Laden der Lizenz Gruppen aus der Lizenz-OU.", "Fehler", "OK", "Error")
}

# Ereignis: Details der ausgewählten Lizenzgruppe anzeigen (rechte Gruppen)
$checkedListBoxLicense.Add_SelectedIndexChanged({
    $selectedLicenseGroup = $checkedListBoxLicense.SelectedItem
    if ($selectedLicenseGroup) {
        try {
            # Nur die Notizen der ausgewählten Lizenzgruppe abfragen
            $licenseGroupDetails = Get-ADGroup -Identity $selectedLicenseGroup -Properties Info
            if ($licenseGroupDetails) {
                # Nur die Notizen (Info) anzeigen
                $txtLicenseGroupDetails.Text = $licenseGroupDetails.Info
            } else {
                $txtLicenseGroupDetails.Text = "Keine Notizen verfügbar."
            }
        } catch {
            $txtLicenseGroupDetails.Text = "Fehler beim Abrufen der Notizen: $_"
        }
    } else {
        $txtLicenseGroupDetails.Text = ""
    }
})

# Benutzer erstellen Button
$y += 400
$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "Benutzer erstellen"
$btnCreate.Size = New-Object System.Drawing.Size(150, 30)
$btnCreate.Location = New-Object System.Drawing.Point(225, $y)
$form.Controls.Add($btnCreate)

# Benutzer erstellen Event
$btnCreate.Add_Click({
    # ... Benutzer erstellen Logik ...
})

# Formular anzeigen
[void]$form.ShowDialog()