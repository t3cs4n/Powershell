<#

 
 Copy Userdesktop folder to All User Documents


#>



# Define the source path (Desktop folder)

$sourcePath = "$env:USERPROFILE\Desktop"

# Define the destination path (Replace 'C:\Backup\Desktop' with your desired location)

$destinationPath = "C:\users\public\documents"

# Copy the Desktop folder content recursively (including subfolders and files)

Try {
  Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
  Write-Host "Desktop folder copied successfully to: $destinationPath"
}
Catch {
  Write-Error "Error copying Desktop folder: $($_.Exception.Message)"
}
