
# Vorgegebene Links via Windows Menu auswählen und auf den Benutzer Desktop kopieren



Add-Type -AssemblyName PresentationFramework

# Liste der vorgegebenen Verknüpfungen (Pfad anpassen)
$shortcuts = @(
    "\\netapp01\IT_Public\Scanning\Source\Scans Elgg.lnk",
    "\\netapp01\IT_Public\Scanning\Source\Scans Elsau.lnk",
    "\\netapp01\IT_Public\Scanning\Source\Scans Wiesendangen.lnk",
    "\\netapp01\IT_Public\Scanning\Source\Scans HR.lnk",
    "\\netapp01\IT_Public\Scanning\Source\Scans PZE.lnk"
)

# Zielordner (Desktop des aktuellen Benutzers)
$desktopPath = [Environment]::GetFolderPath("Desktop")

# Erstellen der GUI
[void][System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework")

# Fenster
$window = New-Object System.Windows.Window
$window.Title = "Shortcut-Kopierer"
$window.SizeToContent = "WidthAndHeight"
$window.WindowStartupLocation = "CenterScreen"
$window.ResizeMode = "NoResize"

# Layout
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Margin = "10"
$stackPanel.Orientation = "Vertical"

# Beschreibung
$description = New-Object System.Windows.Controls.TextBlock
$description.Text = "Wähle die Verknüpfungen aus, die auf den Desktop kopiert werden sollen:"
$description.Margin = "0,0,0,10"
$description.FontSize = 14
$stackPanel.Children.Add($description)

# Listbox
$listBox = New-Object System.Windows.Controls.ListBox
$listBox.SelectionMode = "Extended"
$listBox.Height = 150
foreach ($shortcut in $shortcuts) {
    $listBox.Items.Add((Get-Item $shortcut).Name)
}
$stackPanel.Children.Add($listBox)

# Button
$button = New-Object System.Windows.Controls.Button
$button.Content = "Ausführen"
$button.Margin = "0,10,0,0"
$button.HorizontalAlignment = "Center"
$stackPanel.Children.Add($button)

# Button-Aktion
$button.Add_Click({
    $selectedItems = $listBox.SelectedItems
    if ($selectedItems.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Bitte wähle mindestens eine Verknüpfung aus!", "Hinweis", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }

    foreach ($item in $selectedItems) {
        $sourcePath = $shortcuts | Where-Object { (Get-Item $_).Name -eq $item }
        if (Test-Path $sourcePath) {
            Copy-Item $sourcePath -Destination $desktopPath -Force
        }
    }

    [System.Windows.MessageBox]::Show("Die Verknüpfungen wurden erfolgreich auf den Desktop kopiert!", "Erfolg", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
})

# Fensterinhalt setzen und anzeigen
$window.Content = $stackPanel
$window.ShowDialog() | Out-Null