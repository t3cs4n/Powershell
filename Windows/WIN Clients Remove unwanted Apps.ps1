<#

 Remove unwanted pre-installed Apps


#>




Get-AppxPackage -AllUsers Microsoft.Office.OneNote | Remove-AppxPackage

Get-AppxPackage -AllUsers Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
