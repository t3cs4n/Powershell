<#

 Uninstall Microsoft 365 & Microsoft One Note Language installers


#>


# To get a list of installed packages, run the command below


Get-Package -ProviderName Programs -IncludeWindowsInstaller


# To uninstall the packages run the command below. Adapt the name of the package to your needs 



Get-Package -Name "Microsoft 365 Apps for Enterprise - en-gb" | Uninstall-Package
