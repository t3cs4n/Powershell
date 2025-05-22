# Define the path to the folder you want to delete
$folderPath = "C:\users\public\documents\startlayouts"

# Check if the folder exists
if (Test-Path $folderPath) {
    # Delete the folder and all its contents
    Remove-Item -Path $folderPath -Recurse -Force

    Write-Host "Folder and all its contents have been deleted successfully."
} else {
    Write-Host "The folder does not exist."
}