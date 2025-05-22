# Install choco packages by selection with CLI Menu

# Define the list of Chocolatey packages to install
$Packages = @(
    "abaclient",
    "pdfxchangeeditor",
    "notepadplusplus",
    "winrar",
    "firefox",
    "pdf24",
    "logitech-options-plus",
    "adobereader",
    "vscode"
)

# Initialize an empty array for selected packages
$SelectedPackages = @()

# Function to display the CLI menu
function Show-Menu {
    Clear-Host
    Write-Host "Select packages to install:" -ForegroundColor Cyan
    Write-Host "------------------------------------------------"

    for ($i = 0; $i -lt $Packages.Count; $i++) {
        $Index = $i + 1
        $Selected = if ($SelectedPackages -contains $Packages[$i]) { "X" } else { " " }
        Write-Host "$Index. [$Selected] $($Packages[$i])"
    }

    Write-Host "`nInstructions:" -ForegroundColor Yellow
    Write-Host " - Enter the number of the package to toggle selection."
    Write-Host " - Press Enter when finished."
}

# Main loop for selection
do {
    Show-Menu
    $Input = Read-Host "Enter a number (or press Enter to finish)"

    if ($Input -match '^\d+$') {
        $Index = [int]$Input - 1
        if ($Index -ge 0 -and $Index -lt $Packages.Count) {
            # Toggle the selection
            if ($SelectedPackages -contains $Packages[$Index]) {
                $SelectedPackages = $SelectedPackages | Where-Object { $_ -ne $Packages[$Index] }
            } else {
                $SelectedPackages += $Packages[$Index]
            }
        } else {
            Write-Host "Invalid selection. Please enter a number between 1 and $($Packages.Count)." -ForegroundColor Red
        }
    } elseif ($Input -ne "") {
        Write-Host "Invalid input. Please enter a number." -ForegroundColor Red
    }

} while ($Input -ne "")

# Proceed with installation for selected packages
if ($SelectedPackages.Count -gt 0) {
    Write-Host "`nStarting installation of selected packages..." -ForegroundColor Green
    foreach ($Package in $SelectedPackages) {
        try {
            # Install the selected package
            choco install $Package -y
            Write-Host "Successfully installed $Package" -ForegroundColor Green
        } catch {
            Write-Host "Failed to install $Package. Error: $_" -ForegroundColor Red
        }
    }
} else {
    Write-Host "`nNo packages selected. Exiting." -ForegroundColor Yellow
}