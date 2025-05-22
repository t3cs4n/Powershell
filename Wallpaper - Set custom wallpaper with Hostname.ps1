# Set custom wallpaper with hostname in center


# Check if System.Drawing is loaded, and load it if necessary
try {
    if (-not ("System.Drawing.Bitmap" -as [type])) {
        Add-Type -AssemblyName System.Drawing
    }
} catch {
    Write-Error "System.Drawing could not be loaded. This script requires Windows PowerShell 5.1 or .NET Framework support."
    return
}

# Define parameters
$hostname = $env:COMPUTERNAME
$backgroundImagePath = "C:\Users\Public\Pictures\wallpapers\BlueMoon.jpg"  # Path to your custom background image
$outputImagePath = "$env:TEMP\desktop_background_with_hostname.png"  # Temporary path for the modified image

# Load the custom background image
try {
    $backgroundImage = [System.Drawing.Image]::FromFile($backgroundImagePath)
} catch {
    Write-Error "Failed to load background image from $backgroundImagePath. Make sure the path is correct."
    return
}

# Set up font and colors
$fontSize = 80
$font = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
$textColor = [System.Drawing.Color]::White

# Create a graphics object from the image to overlay text
$graphics = [System.Drawing.Graphics]::FromImage($backgroundImage)

# Define text position (centered on the image)
$textSize = $graphics.MeasureString($hostname, $font)
$x = ($backgroundImage.Width - $textSize.Width) / 2
$y = ($backgroundImage.Height - $textSize.Height) / 2

# Draw the hostname text on the image
$brush = New-Object System.Drawing.SolidBrush $textColor
$graphics.DrawString($hostname, $font, $brush, $x, $y)

# Save the modified image
$backgroundImage.Save($outputImagePath, [System.Drawing.Imaging.ImageFormat]::Png)

# Release resources
$graphics.Dispose()
$backgroundImage.Dispose()

# Set the new image as the desktop background
$code = @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
Add-Type -TypeDefinition $code -Language CSharp
[Wallpaper]::SystemParametersInfo(0x0014, 0, $outputImagePath, 0x0001 -bor 0x0002)

Write-Output "Desktop background updated with hostname: $hostname"