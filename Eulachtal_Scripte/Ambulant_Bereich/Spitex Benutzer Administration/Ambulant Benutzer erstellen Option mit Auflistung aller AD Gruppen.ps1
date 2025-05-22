

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
        $txt.UseSystemPasswordChar = $true
    }
    $form.Controls.Add($txt)
    $controls += $txt

    $y += 40
}

# Domain-Suffix Dropdown hinzufügen
$lblDomain = New-Object System.Windows.Forms.Label
$lblDomain.Text = "Domain-Suffix"
$lblDomain.Size = New-Object System.Drawing.Size(250, 20)
$lblDomain.Location = New-Object System.Drawing.Point(10, $y)
$form.Controls.Add($lblDomain)

$comboDomain = New-Object System.Windows.Forms.ComboBox
$comboDomain.Items.AddRange(@("eulachtal.ch")) # ,"example.com", "test.local"))  # Suffixe anpassbar
$comboDomain.SelectedIndex = 0
$comboDomain.Size = New-Object System.Drawing.Size(200, 20)
$comboDomain.Location = New-Object System.Drawing.Point(270, $y) 
$form.Controls.Add($comboDomain)
$y += 40

# Gruppenlisten für lokale Gruppen
$lblGroupsLocal = New-Object System.Windows.Forms.Label
$lblGroupsLocal.Text = "Ambulant Bereich Gruppen zuweisen"
$lblGroupsLocal.Size = New-Object System.Drawing.Size(250, 20)
$lblGroupsLocal.Location = New-Object System.Drawing.Point(10, $y)
$form.Controls.Add($lblGroupsLocal)

$checkedListBoxLocal = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxLocal.Size = New-Object System.Drawing.Size(250, 150)
$checkedListBoxLocal.Location = New-Object System.Drawing.Point(10, ($y + 30))
$form.Controls.Add($checkedListBoxLocal)

# Lizenzgruppen
$lblGroupsLicense = New-Object System.Windows.Forms.Label
$lblGroupsLicense.Text = "Lizenz Gruppen zuweisen"
$lblGroupsLicense.Size = New-Object System.Drawing.Size(250, 20)
$lblGroupsLicense.Location = New-Object System.Drawing.Point(270, $y)
$form.Controls.Add($lblGroupsLicense)

$checkedListBoxLicense = New-Object System.Windows.Forms.CheckedListBox
$checkedListBoxLicense.Size = New-Object System.Drawing.Size(250, 150)
$checkedListBoxLicense.Location = New-Object System.Drawing.Point(270, ($y + 30))
$form.Controls.Add($checkedListBoxLicense)

# Lokale Gruppen aus der definierten OU laden
try {
    $localGroups = Get-ADGroup -Filter * -SearchBase $groupOU | Select-Object -ExpandProperty Name
    foreach ($group in $localGroups) {
        $checkedListBoxLocal.Items.Add($group)
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("Fehler beim Laden der lokalen Gruppen aus der Gruppen-OU.", "Fehler", "OK", "Error")
}

# Lizenz Gruppen aus der definierten OU laden
try {
    $licenseGroups = Get-ADGroup -Filter * -SearchBase $licenseGroupOU | Select-Object -ExpandProperty Name
    foreach ($group in $licenseGroups) {
        $checkedListBoxLicense.Items.Add($group)
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("Fehler beim Laden der Lizenz Gruppen aus der Lizenz-OU.", "Fehler", "OK", "Error")
}

# Benutzer erstellen Button
$y += 400
$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "Benutzer erstellen"
$btnCreate.Size = New-Object System.Drawing.Size(150, 30)
$btnCreate.Location = New-Object System.Drawing.Point(225, $y)
$form.Controls.Add($btnCreate)

# Benutzer erstellen Event
$btnCreate.Add_Click({
    $samAccountName = $controls[0].Text
    $givenName = $controls[1].Text
    $surname = $controls[2].Text
    $email = $controls[3].Text
    $password = $controls[4].Text
    $domainSuffix = $comboDomain.SelectedItem  # Neues Feld

    if (-not $samAccountName -or -not $givenName -or -not $surname -or -not $email -or -not $password) {
        [System.Windows.Forms.MessageBox]::Show("Bitte alle Felder ausfüllen!", "Fehler", "OK", "Error")
        return
    }

    try {
        # UPN und E-Mail mit gewähltem Suffix erstellen
        $upn = "$samAccountName@$domainSuffix"
        $email = "$samAccountName@$domainSuffix"

        New-ADUser -SamAccountName $samAccountName -UserPrincipalName $upn -GivenName $givenName -Surname $surname -Name "$givenName $surname" -EmailAddress $email -Path $OU -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true | Out-Null
        
        # Gruppen zuweisen (unverändert)
        foreach ($group in $checkedListBoxLocal.CheckedItems) {
            Add-ADGroupMember -Identity $group -Members $samAccountName
        }
        foreach ($group in $checkedListBoxLicense.CheckedItems) {
            Add-ADGroupMember -Identity $group -Members $samAccountName
        }
        
        [System.Windows.Forms.MessageBox]::Show("Benutzer $samAccountName wurde erfolgreich erstellt!", "Erfolg", "OK", "Information")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Fehler: $_", "Fehler", "OK", "Error")
    }
})

# Formular anzeigen
[void]$form.ShowDialog()