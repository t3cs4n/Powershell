<#

 Copy link files to the default user startmenu folder
 
 Edit the Path lines to match wanted locations

#>


# Define source and destination paths

$sourcePath = "T:\__IT_TEMP\ClientDesign\Programme"
$destinationPath = "$Env:userprofile\\AppData\Roaming\Microsoft\Windows\Start Menu\"

# Copy all files with .lnk extension (adjust *.lnk for your extension)
# Copy-Item -Path "$sourcePath\*.lnk" -Destination $destinationPath -Force

# (Optional) Include subfolders with -Recurse parameter

Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Filter "*.lnk" -Force



