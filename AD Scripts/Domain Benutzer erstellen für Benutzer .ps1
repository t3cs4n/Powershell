
# Importieren der Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms

# Prüfen, ob das Active Directory-Modul vorhanden ist
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    [System.Windows.Forms.MessageBox]::Show("Das Active Directory-Modul ist nicht installiert. Bitte installieren Sie die RSAT-AD-Tools.", "Fehler", "OK", "Error")
    exit
}

# Vordefinierte Domain
$Domain = "DC=eulachtal,DC=zh"

# Formular erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Neuen AD-Benutzer erstellen"
$form.Size = New-Object System.Drawing.Size(350, 400)
$form.StartPosition = "CenterScreen"

# Labels und Eingabefelder erstellen
$controls = @()
$labels = "Vorname", "Nachname", "E-Mail-Adresse", "SMTP-Proxy-Adresse", "OU-Name"
$y = 20
foreach ($label in $labels) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $label
    $lbl.Size = New-Object System.Drawing.Size(120, 20)
    $lbl.Location = New-Object System.Drawing.Point(10, $y)
    $form.Controls.Add($lbl)
    
    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Size = New-Object System.Drawing.Size(180, 20)
    $txt.Location = New-Object System.Drawing.Point(150, $y)
    $form.Controls.Add($txt)
    $controls += $txt

    $y += 40
}

# Button zum Erstellen des Benutzers
$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "Benutzer erstellen"
$btnCreate.Size = New-Object System.Drawing.Size(120, 30)
$btnCreate.Location = New-Object System.Drawing.Point(100, 280)
$form.Controls.Add($btnCreate)

# Ergebnislabel
$resultLabel = New-Object System.Windows.Forms.Label
$resultLabel.Size = New-Object System.Drawing.Size(300, 50)
$resultLabel.Location = New-Object System.Drawing.Point(10, 320)
$form.Controls.Add($resultLabel)

# Funktion zum Erstellen des Benutzers
$btnCreate.Add_Click({
    $Vorname = $controls[0].Text
    $Nachname = $controls[1].Text
    $Email = $controls[2].Text
    $SmtpProxy = $controls[3].Text
    $OUName = $controls[4].Text
    $OU = "OU=$OUName,$Domain"

    try {
        # OU prüfen
        Get-ADOrganizationalUnit -Identity $OU -ErrorAction Stop

        # Benutzername erstellen
        $Username = "$Vorname.$Nachname".ToLower()

        # Prüfen, ob der Benutzer existiert
        if (Get-ADUser -Filter {SamAccountName -eq $Username}) {
            $resultLabel.Text = "Der Benutzer '$Username' existiert bereits."
            return
        }

        # Passwort generieren (Standardpasswort)
        $Password = "P@ssw0rd123!" | ConvertTo-SecureString -AsPlainText -Force

        # Benutzer erstellen
        New-ADUser -Name "$Vorname $Nachname" `
                   -GivenName $Vorname `
                   -Surname $Nachname `
                   -SamAccountName $Username `
                   -UserPrincipalName "$Username@example.com" `
                   -EmailAddress $Email `
                   -OtherAttributes @{ "proxyAddresses" = "SMTP:$SmtpProxy" } `
                   -Path $OU `
                   -AccountPassword $Password `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true

        $resultLabel.Text = "Benutzer '$Username' erfolgreich erstellt!"
    } catch {
        $resultLabel.Text = "Fehler: $_"
    }
})

# Formular anzeigen
[void]$form.ShowDialog()