function Do-Menu {
    [CmdletBinding()]
    param (
        [string]$Path   = $PWD,  # default to current working directory
        [string]$Filter = 'Image*',
        [string]$Title  = 'Please select the folder(s) to move'
    )
    cls

    # if you only want to match the name on a single wildcard string, use Filter, not Include
    $dirs = @(Get-childitem -Path $Path -Filter $Filter -Recurse -Directory) | Sort-Object LastWriteTime
    # only proceed if there are directories found by that name
    if (!$dirs.Count) {
        Write-Host "No directories found that match filter '$Filter'.."
        return $false  # exit the function with a value of False
    }
    # create the menu
    if (![string]::IsNullOrWhiteSpace($Title)) {
        $dashLine = '-' * ($Title -split '\r?\n' | Measure-Object -Maximum -Property Length).Maximum
        Write-Host "$Title`r`n$dashLine`r`n" -ForegroundColor Yellow
    }

    $index  = 1
    $dirs | ForEach-Object {
        # write out the menu items
        $align = $dirs.Count.ToString().Length
        # {0,$align} aligns the index number to the right
        # for more DateTime formats see
        # https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
        # https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings
        Write-Host ("{0,$align}. {1:yyyy-MM-dd HH:mm:ss}  {2}" -f $index++, $_.LastWriteTime, $_.FullName)  
    }
    # now ask for user input
    $message = "`r`nType the index number of the directory you wish to delete.`r`n"
    if ($dirs.Count -gt 1) { $message += "To select multiple items, separate the numbers with commas.`r`n" }
    Write-Host $message -ForegroundColor Yellow

    $selection = Read-Host
    # make sure the input is all numeric and contains no '0' values
    # or values higher than the number of directories
    $selection = [int[]]($selection -replace '[^\d,]' -split ',' | 
                         Where-Object { $_ -match '\d+' -and ([int]$_ -gt 0 -and [int]$_ -le $dirs.Count)})

    if (!$selection.Count) { return $false }  # exit on empty input

    # loop over the selected indices and delete the matching folders
    $selection | ForEach-Object {
        $folder = $dirs[$_ - 1]
        # make sure you are not trying to remove a folder of which the parent
        # folder has just been removed
        if (Test-Path -Path $folder.FullName -PathType Container) {
            $folder | Move-Item -Destination $targetdir
            Write-Host "Folder $($folder.FullName) has been moved"
        }
    }
    # return True to have the menu rebuilt after a short pause
    Start-Sleep 4
    $true
}

# main code
$path = 'E:\TestEnv\Repository\images'
$targetdir = 'E:\TestEnv\deleted_images' 

while ($true) {
    $result = Do-Menu -Path $path
    # if the user cancelled, or if there were no folders matching the filter, exit the while loop
    if (!$result) { break }
}
cls
Write-Host "`r`nAll done!" -ForegroundColor Green