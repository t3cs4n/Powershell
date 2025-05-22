# Run Windows Updates / Ignore Reboot

# Set execution policy to allow script execution (if needed)
# Set-ExecutionPolicy Bypass -Scope Process -Force

# Import Windows Update Module
if (-not (Get-Module -Name PSWindowsUpdate -ListAvailable)) {
    Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
}
Import-Module PSWindowsUpdate

# Install available updates without restarting
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot

Write-Host "Windows-Updates wurden installiert. Ein Neustart ist erforderlich, aber wurde nicht durchgeführt."
