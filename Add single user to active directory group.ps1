# Add single user to active directory group by menu

# Check if the script is running as an administrator

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # If not running as admin, restart with elevated privileges
    Write-Host "Restarting script with elevated privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Confirm elevation and continue with the main script
Write-Host "Script is running with elevated privileges."



# Import the Active Directory module (if available)
Import-Module ActiveDirectory -ErrorAction SilentlyContinue

# Define the XAML for the WPF window
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Add User to Group" Width="400" Height="250" WindowStartupLocation="CenterScreen" Background="#f2f2f2">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <TextBlock Text="Add User to Group in Active Directory" FontSize="16" FontWeight="Bold" Margin="0,0,0,10" Grid.Row="0" HorizontalAlignment="Center"/>

        <TextBlock Text="Username:" Grid.Row="1" VerticalAlignment="Center" Margin="0,5,0,0"/>
        <TextBox Name="UsernameTextBox" Grid.Row="1" Width="200" Height="25" Margin="80,5,0,0" HorizontalAlignment="Left"/>

        <TextBlock Text="Group Name:" Grid.Row="2" VerticalAlignment="Center" Margin="0,5,0,0"/>
        <TextBox Name="GroupTextBox" Grid.Row="2" Width="200" Height="25" Margin="80,5,0,0" HorizontalAlignment="Left"/>

        <Button Content="Add User to Group" Grid.Row="3" Width="150" Height="30" Margin="0,10,0,0" HorizontalAlignment="Center" Background="#4CAF50" Foreground="White" FontWeight="Bold"/>

        <TextBlock Name="ResultLabel" Grid.Row="4" Text="" Foreground="Gray" FontSize="14" HorizontalAlignment="Center" Margin="0,20,0,0"/>
    </Grid>
</Window>
"@

# Load WPF Assemblies
Add-Type -AssemblyName PresentationCore, PresentationFramework

# Parse XAML and create the window
$Reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$XAML)
$Window = [System.Windows.Markup.XamlReader]::Load($Reader)

# Find controls by name
$UsernameTextBox = $Window.FindName("UsernameTextBox")
$GroupTextBox = $Window.FindName("GroupTextBox")
$ResultLabel = $Window.FindName("ResultLabel")
$AddButton = $Window.FindName("AddButton")

# Event Handler for the button click
$AddButton.Add_Click({
    $userName = $UsernameTextBox.Text
    $groupName = $GroupTextBox.Text

    # Check if both the user and the group exist
    $user = Get-ADUser -Identity $userName -ErrorAction SilentlyContinue
    $group = Get-ADGroup -Identity $groupName -ErrorAction SilentlyContinue

    if ($user -and $group) {
        # Add the user to the group
        Add-ADGroupMember -Identity $groupName -Members $userName
        $ResultLabel.Text = "User '$userName' has been successfully added to '$groupName'."
        $ResultLabel.Foreground = "Green"
    } else {
        # Display error if user or group not found
        $ResultLabel.Text = "Error: " + `
            (if (-not $user) { "User '$userName' not found. " } else { "" }) + `
            (if (-not $group) { "Group '$groupName' not found." } else { "" })
        $ResultLabel.Foreground = "Red"
    }
})

# Show the WPF window
$Window.ShowDialog()