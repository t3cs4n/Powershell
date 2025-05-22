<#

 Create a shortcut from a specific folder on the desktop of the current working user. 


#>

# Define the folder path you want a shortcut to (replace with your actual path)

$targetFolder = "C:\Users\public\Documents\Desktop"

# Define the shortcut filename and location on Desktop (replace with your desired name)

$shortcutPath = "$env:USERPROFILE\Desktop\Alte Desktop Dateien.lnk"

# Create a new WScript.Shell object

$wshShell = New-Object -ComObject WScript.Shell

# Create a shortcut object

$shortcut = $wshShell.CreateShortcut($shortcutPath)

# Set the target path of the shortcut to the folder

$shortcut.TargetPath = $targetFolder

# Save the shortcut

$shortcut.Save()

Write-Host "Shortcut created successfully: $shortcutPath"
