# Load WPF Assemblies
Add-Type -AssemblyName PresentationCore, PresentationFramework

# Define XAML for the main window
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Move File and Create Shortcut" Width="400" Height="300" WindowStartupLocation="CenterScreen">
    <StackPanel Margin="10">
        <TextBlock Text="File to Move:" Margin="0,0,0,5"/>
        <TextBox Name="FilePathTextBox" Width="300" Height="25"/>
        <Button Content="Browse File" Width="100" Margin="0,5,0,10" Name="FileBrowseButton"/>

        <TextBlock Text="Shortcut to Delete:" Margin="10,10,0,5"/>
        <TextBox Name="ShortcutPathTextBox" Width="300" Height="25"/>
        <Button Content="Browse Shortcut" Width="100" Margin="0,5,0,10" Name="ShortcutBrowseButton"/>

        <Button Name="ExecuteButton" Content="Execute" Width="100" Height="30" Background="#4CAF50" Foreground="White" FontWeight="Bold" HorizontalAlignment="Center" Margin="0,10,0,0"/>
        <TextBlock Name="ResultLabel" Text="" Foreground="Gray" FontSize="14" HorizontalAlignment="Center" Margin="0,20,0,0"/>
    </StackPanel>
</Window>
"@

# Parse the XAML and create the window
$Reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$XAML)
$Window = [System.Windows.Markup.XamlReader]::Load($Reader)

# Define the controls for ease of access
$FilePathTextBox = $Window.FindName("FilePathTextBox")
$FileBrowseButton = $Window.FindName("FileBrowseButton")
$ShortcutPathTextBox = $Window.FindName("ShortcutPathTextBox")
$ShortcutBrowseButton = $Window.FindName("ShortcutBrowseButton")
$ExecuteButton = $Window.FindName("ExecuteButton")
$ResultLabel = $Window.FindName("ResultLabel")

# Hardcoded destination path set to "C:\Program Files\NewTeams"
$destinationFolder = "C:\Program Files\NewTeams"
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")

# File browse functionality
$FileBrowseButton.Add_Click({
    $FileDialog = New-Object -TypeName Microsoft.Win32.OpenFileDialog
    if ($FileDialog.ShowDialog()) {
        $FilePathTextBox.Text = $FileDialog.FileName
    }
})

# Shortcut browse functionality (for selecting the shortcut to delete)
$ShortcutBrowseButton.Add_Click({
    $ShortcutDialog = New-Object -TypeName Microsoft.Win32.OpenFileDialog
    $ShortcutDialog.Filter = "Shortcut Files (*.lnk)|*.lnk"
    $ShortcutDialog.InitialDirectory = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
    if ($ShortcutDialog.ShowDialog()) {
        $ShortcutPathTextBox.Text = $ShortcutDialog.FileName
    }
})

# Execution logic
$ExecuteButton.Add_Click({
    # Retrieve input values
    $fileToMove = $FilePathTextBox.Text
    $shortcutToDelete = $ShortcutPathTextBox.Text

    # Check if the file input is provided
    if (-not $fileToMove) {
        $ResultLabel.Text = "Please select a file to move."
        $ResultLabel.Foreground = "Red"
        return
    }

    # Delete the specified shortcut if it exists
    if ($shortcutToDelete) {
        if (Test-Path -Path $shortcutToDelete) {
            Remove-Item -Path $shortcutToDelete -Force
            $ResultLabel.Text = "Shortcut '$shortcutToDelete' deleted."
            $ResultLabel.Foreground = "Gray"
        } else {
            $ResultLabel.Text = "Shortcut '$shortcutToDelete' not found."
            $ResultLabel.Foreground = "Red"
            return
        }
    }

    # Check or create the destination folder
    if (-not (Test-Path -Path $destinationFolder)) {
        try {
            # Attempt to create the directory (requires admin privileges)
            New-Item -ItemType Directory -Path $destinationFolder -Force | Out-Null
        } catch {
            $ResultLabel.Text = "Error creating directory: $_"
            $ResultLabel.Foreground = "Red"
            return
        }
    }

    # Move the specified file
    if (Test-Path -Path $fileToMove) {
        try {
            # Define the destination file path
            $destinationFilePath = [System.IO.Path]::Combine($destinationFolder, [System.IO.Path]::GetFileName($fileToMove))

            # Move the file to the destination folder
            Move-Item -Path $fileToMove -Destination $destinationFolder -Force
            $ResultLabel.Text = "File moved to: $destinationFolder"
            $ResultLabel.Foreground = "Green"

            # Create a shortcut on the desktop for the moved file
            $WScriptShell = New-Object -ComObject WScript.Shell
            $shortcutPathOnDesktop = [System.IO.Path]::Combine($desktopPath, "New Teams.lnk")
            $shortcut = $WScriptShell.CreateShortcut($shortcutPathOnDesktop)
            $shortcut.TargetPath = $destinationFilePath
            $shortcut.Save()

            # Show completion message
            $ResultLabel.Text = "File moved and shortcut created on Desktop!"
            $ResultLabel.Foreground = "Green"
        } catch {
            $ResultLabel.Text = "Error moving file or creating shortcut: $_"
            $ResultLabel.Foreground = "Red"
        }
    } else {
        $ResultLabel.Text = "File '$fileToMove' not found."
        $ResultLabel.Foreground = "Red"
    }
})

# Show the WPF window
$Window.ShowDialog()