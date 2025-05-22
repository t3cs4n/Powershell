<#

This part of the script will copy all the items for the startmenu
to the client.

Copy Powershell Scrips files to the public user pictures folder

Edit the Path lines to match wanted locations

#>


# Define source and destination paths
# $sourcePath = "\\netapp01\daten\15_Temp\__IT_TEMP\ClientDesign\powershell_scripts"
# $destinationPath = "C:\Users\Public\Documents\Powershell_Scripts"

# Copy all files with .lnk extension (adjust *.lnk for your extension)
# Copy-Item -Path "$sourcePath\*.lnk" -Destination $destinationPath -Force

# (Optional) Include subfolders with -Recurse parameter


# Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Filter "*.ps1" -Force

# The copy job above was solved via a selfextracting Zip file.


<#

Copy link files to the default user startmenu folder

Edit the Path lines to match wanted locations

#>


# Define source and destination paths

$sourcePath = "\\netapp01\daten\15_Temp\__IT_TEMP\ClientDesignPROD\programme\"
$destinationPath = "$Env:profile\AppData\Roaming\Microsoft\Windows\Start Menu\"

# Copy all files with .lnk extension (adjust *.lnk for your extension)
# Copy-Item -Path "$sourcePath\*.lnk" -Destination $destinationPath -Force

# (Optional) Include subfolders with -Recurse parameter

Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Filter "*.lnk" -Force


<#

Copy ICON files to the public user pictures folder

Edit the Path lines to match wanted locations

# Define source and destination paths
$sourcePath = "\\netapp01\daten\15_Temp\__IT_TEMP\ClientDesign\ICONS"
$destinationPath = "C:\Users\Public\Pictures\ICONS"

# Copy all files with .lnk extension (adjust *.lnk for your extension)
# Copy-Item -Path "$sourcePath\*.lnk" -Destination $destinationPath -Force

# (Optional) Include subfolders with -Recurse parameter
Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Filter "*.*" -Force

The copy job above was solved via a selfextracting Zip file.

#>

pause
