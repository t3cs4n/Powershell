# Install choco packages by selection with Grid-View menu

# Define the list of Chocolatey packages to install
$Packages = @(
    "abaclient",
    "pdfxchangeeditor",
    "notepadplusplus",
    "winrar",
    "firefox",
    "pdf24"
    "logitech-options-plus"
    "adobereader"
    "vscode"
)

# Display a selection menu using Out-GridView
$SelectedPackages = $Packages | Out-GridView -Title "Select Packages to Install" -PassThru

# Proceed only if packages are selected
if ($SelectedPackages) {
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
    Write-Host "No packages selected. Exiting." -ForegroundColor Yellow
}