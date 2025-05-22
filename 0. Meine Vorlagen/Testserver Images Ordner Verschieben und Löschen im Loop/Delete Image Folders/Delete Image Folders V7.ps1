$path = 'E:\TestEnv\deleted_images'
# enter an endless loop. We'll break out if the user clicks the Cancel button
# or when there are no directories found that match the name in the Filter
while ($true) {
    # if you only want to match the name on a single wildcard string, use Filter, not Include
    $dirs = Get-childitem -Path $path -Filter 'Image*' -Recurse -Directory | Sort-Object LastAccessTime
    # only proceed if there are directories found by that name
    if (@($dirs).Count) {
        $selection = $dirs | Out-GridView -Title 'Please select the folder(s) to delete' -PassThru
        # if the user cancelled, exit the while loop
        if (!$selection) { break }

        # the user could have selected more than one directory, so use a loop
        $selection | ForEach-Object { 
            $_ | Remove-Item -Recurse
            Write-Host "Folder $($_.FullName) has been deleted"
        }
    }
    else {
        Write-Host "No directories found that match the filter.."
        break  # no directory by that name found, so exit the while loop
    }
}

Write-Host "All done" -ForegroundColor Green