# Option mit Auflistung aller AD Gruppen


# Spitex Benutzer erstellen

# Importieren der Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms

# Prüfen, ob das Active Directory-Modul vorhanden ist
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    [System.Windows.Forms.MessageBox]::Show("Das Active Directory-Modul ist nicht installiert. Bitte installieren Sie die RSAT-AD-Tools.", "Fehler", "OK", "Error")
    exit
}

# Festgelegte OU (vollständiger Pfad)
$OU = "OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Formular erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Neuen AD-Benutzer erstellen"
$form.Size = New-Object System.Drawing.Size(500, 750)
$form.StartPosition = "CenterScreen"

# Labels und Eingabefelder erstellen
$controls = @()
$labels = "Vorname", "Nachname", "E-Mail-Adresse", "SMTP-Proxy-Adresse", "Passwort", "Beschreibung"
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

# Gruppenliste hinzufügen
$lblGroups = New-Object System.Windows.Forms.Label
$lblGroups.Text = "Gruppenmitgliedschaft"
$lblGroups.Size = New-Object System.Drawing.Size(250, 20)
$lblGroups.Location = New-Object System.Drawing.Point(10, $y)
$form.Controls.Add($lblGroups)

$checkedListBox = New-Object System.Windows.Forms.CheckedListBox
$checkedListBox.Size = New-Object System.Drawing.Size(300, 150)
$checkedListBox.Location = New-Object System.Drawing.Point(10, ($y + 30)) # Korrigierte Punktdefinition
$form.Controls.Add($checkedListBox)

# Verfügbare Gruppen abrufen und zur Liste hinzufügen
$groups = Get-ADGroup -Filter * | Select-Object -ExpandProperty Name
foreach ($group in $groups) {
    $checkedListBox.Items.Add($group)
}
$y += 200

# Button zum Erstellen des Benutzers
$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "Benutzer erstellen"
$btnCreate.Size = New-Object System.Drawing.Size(150, 30)
$btnCreate.Location = New-Object System.Drawing.Point(175, $y)
$form.Controls.Add($btnCreate)

# Ergebnislabel
$resultLabel = New-Object System.Windows.Forms.Label
$resultLabel.Size = New-Object System.Drawing.Size(450, 50)
$resultLabel.Location = New-Object System.Drawing.Point(25, ($y + 50)) # Korrigierte Punktdefinition
$form.Controls.Add($resultLabel)

# Funktion zum Erstellen des Benutzers
$btnCreate.Add_Click({
    $Vorname = $controls[0].Text
    $Nachname = $controls[1].Text
    $Email = $controls[2].Text
    $SmtpProxy = $controls[3].Text
    $PasswordPlain = $controls[4].Text
    $Description = $controls[5].Text

    try {
        # Passwort in SecureString konvertieren
        $Password = ConvertTo-SecureString -String $PasswordPlain -AsPlainText -Force

        # Benutzername erstellen
        $Username = "$Vorname.$Nachname".ToLower()

        # Prüfen, ob der Benutzer existiert
        if (Get-ADUser -Filter {SamAccountName -eq $Username}) {
            $resultLabel.Text = "Der Benutzer '$Username' existiert bereits."
            return
        }

        # Benutzer erstellen
        New-ADUser -Name "$Vorname $Nachname" `
                   -GivenName $Vorname `
                   -Surname $Nachname `
                   -SamAccountName $Username `
                   -UserPrincipalName "$Username@example.com" `
                   -EmailAddress $Email `
                   -OtherAttributes @{ "proxyAddresses" = "SMTP:$SmtpProxy"; "description" = $Description } `
                   -Path $OU `
                   -AccountPassword $Password `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true

        # Ausgewählte Gruppen abrufen und hinzufügen
        $selectedGroups = @()
        foreach ($index in $checkedListBox.CheckedIndices) {
            $selectedGroups += $checkedListBox.Items[$index]
        }

        foreach ($groupName in $selectedGroups) {
            $group = Get-ADGroup -Filter {Name -eq $groupName}
            Add-ADGroupMember -Identity $group.DistinguishedName -Members $Username
        }

        $resultLabel.Text = "Benutzer '$Username' erfolgreich erstellt und zu den Gruppen hinzugefügt!"
    } catch {
        $resultLabel.Text = "Fehler: $_"
    }
})

# Formular anzeigen
[void]$form.ShowDialog()