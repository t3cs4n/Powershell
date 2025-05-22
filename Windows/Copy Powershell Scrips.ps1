<#

 Copy Powershell Scrips files to the public user pictures folder
 
 Edit the Path lines to match wanted locations

#>


# Define source and destination paths

$sourcePath = "T:\__IT_TEMP\ClientDesign\powershell_scripts"
$destinationPath = "C:\Users\Public\Documents\Powershell_Scripts"

# Copy all files with .lnk extension (adjust *.lnk for your extension)
# Copy-Item -Path "$sourcePath\*.lnk" -Destination $destinationPath -Force

# (Optional) Include subfolders with -Recurse parameter

Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Filter "*.ps1" -Force

