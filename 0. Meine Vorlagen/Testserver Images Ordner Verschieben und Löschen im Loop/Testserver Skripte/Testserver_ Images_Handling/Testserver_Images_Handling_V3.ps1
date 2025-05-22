<# 
.NAME
    Test Server Images Handling
#>

<#Enter-PSSession sHVH20


Pause

Write-Host "Drücke Enter zum weiterfahren!"
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Testserver_Images_Handling      = New-Object system.Windows.Forms.Form
$Testserver_Images_Handling.ClientSize  = New-Object System.Drawing.Point(490,478)
$Testserver_Images_Handling.text  = "Test Server Images Handling"
$Testserver_Images_Handling.TopMost  = $false
$Testserver_Images_Handling.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#318181")
<#

$VERBINDEN                       = New-Object system.Windows.Forms.Button
$VERBINDEN.text                  = "VERBINDEN"
$VERBINDEN.width                 = 160
$VERBINDEN.height                = 60
$VERBINDEN.location              = New-Object System.Drawing.Point(161,130)
$VERBINDEN.Font                  = New-Object System.Drawing.Font('Arial',12,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

#>

$VERSCHIEBEN                     = New-Object system.Windows.Forms.Button
$VERSCHIEBEN.text                = "VERSCHIEBEN"
$VERSCHIEBEN.width               = 160
$VERSCHIEBEN.height              = 60
$VERSCHIEBEN.location            = New-Object System.Drawing.Point(161,245)
$VERSCHIEBEN.Font                = New-Object System.Drawing.Font('Arial',12,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$LÖSCHEN                         = New-Object system.Windows.Forms.Button
$LÖSCHEN.text                    = "LÖSCHEN"
$LÖSCHEN.width                   = 160
$LÖSCHEN.height                  = 60
$LÖSCHEN.location                = New-Object System.Drawing.Point(161,372)
$LÖSCHEN.Font                    = New-Object System.Drawing.Font('Arial',12,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$Logo                            = New-Object system.Windows.Forms.PictureBox
$Logo.width                      = 200
$Logo.height                     = 70
$Logo.location                   = New-Object System.Drawing.Point(140,19)
$Logo.imageLocation              = ".\Firma_Logo_B150px_white_300dpi.png"
$Logo.SizeMode                   = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$Testserver_Images_Handling.controls.AddRange(@($VERBINDEN,$VERSCHIEBEN,$LÖSCHEN,$Logo))


#region Logic 

# $VERBINDEN.Add_Click({Set-Verbinden})
$VERSCHIEBEN.Add_Click({Set-Verschieben})
$LÖSCHEN.Add_Click({Set-Löschen})

<#
function Set-Verbinden(){

#$Server = sHVH20

Enter-PSSession sHVH20

Write-Host = "Du bist nun mit dem Server verbunden"

}
#>

function Set-Verschieben(){

function New-Menu () {
    [CmdletBinding()]
    param (
        [string]$Path   = $PWD,  # default to current working directory
        [string]$Filter = 'Image*',
        [string]$Title  = 'Bitte wähle die Ordner zum verschieben'
    )
    Clear-Host

    # if you only want to match the name on a single wildcard string, use Filter, not Include
    $dirs = @(Get-childitem -Path $Path -Filter $Filter -Recurse -Directory) | Sort-Object LastWriteTime
    # only proceed if there are directories found by that name
    if (!$dirs.Count) {
        Write-Host "Keine Ordner gefunden die dem '$Filter' entsprechen..."
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
    $message = "`r`nTippe die Indexnummer von den Ordner die du verschieben möchtest.`r`n"
    if ($dirs.Count -gt 1) { $message += "Um mehrere auszuwählen, trenne die Zahlen durch Kommas (Bsp: 1,2,3).`r`n" }
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
            Write-Host "Ordner $($folder.FullName) wurde/n verschoben"
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
    $result = New-Menu -Path $path
    # if the user cancelled, or if there were no folders matching the filter, exit the while loop
    if (!$result) { break }
}
Clear-Host
Write-Host "`r`nAlles erledigt!" -ForegroundColor Green

}


function Set-Löschen(){

 function New-Menu {
    [CmdletBinding()]
    param (
        [string]$Path   = $PWD,  # default to current working directory
        [string]$Filter = 'Image*',
        [string]$Title  = 'Bitte wähle die Ordner zum löschen'
    )
    Clear-Host

    # if you only want to match the name on a single wildcard string, use Filter, not Include
    $dirs = @(Get-childitem -Path $Path -Filter $Filter -Recurse -Directory) | Sort-Object LastWriteTime
    # only proceed if there are directories found by that name
    if (!$dirs.Count) {
        Write-Host "Keine Ordner gefunden die dem '$Filter' entsprechen..."
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
    $message = "`r`nTippe die Indexnummer von den Ordner die du löschen möchtest.`r`n"
    if ($dirs.Count -gt 1) { $message += "Um mehrere auszuwählen, trenne die Zahlen durch Kommas (Bsp: 1,2,3).`r`n" }
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
            $folder | Remove-Item -Recurse
            Write-Host "Ordner $($folder.FullName) wurde/n gelöscht"
        }
    }
    # return True to have the menu rebuilt after a short pause
    Start-Sleep 4
    $true
}

# main code
$path = 'E:\TestEnv\deleted_images'

while ($true) {
    $result = New-Menu -Path $path
    # if the user cancelled, or if there were no folders matching the filter, exit the while loop
    if (!$result) { break }
}
Clear-Host
Write-Host "`r`nAlles erledigt!" -ForegroundColor Green 


}

#endregion

[void]$Testserver_Images_Handling.ShowDialog()