<# 
.NAME
    Test Server Images Handling
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Testserver_Images_Handling      = New-Object system.Windows.Forms.Form
$Testserver_Images_Handling.ClientSize  = New-Object System.Drawing.Point(490,478)
$Testserver_Images_Handling.text  = "Test Server Images Handling"
$Testserver_Images_Handling.TopMost  = $false
$Testserver_Images_Handling.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#318181")

$VERBINDEN                       = New-Object system.Windows.Forms.Button
$VERBINDEN.text                  = "VERBINDEN"
$VERBINDEN.width                 = 160
$VERBINDEN.height                = 60
$VERBINDEN.location              = New-Object System.Drawing.Point(161,130)
$VERBINDEN.Font                  = New-Object System.Drawing.Font('Arial',12,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

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

#endregion

$VERBINDEN.Add_Click({Set-Verbinden})

function Set-Verbinden(){

Enter-PSSession sHVH20

}

[void]$Testserver_Images_Handling.ShowDialog()