<#

 Uninstall Outlook New (Replacement for Mail and Calender Apps, which will be EOL at the end of 2024)


#>


Get-AppxPackage -AllUsers | Where-Object {$_.Name -Like '*OutlookForWindows*'} | Remove-AppxPackage -AllUsers -ErrorAction Continue