<#

Show users which have a specific loginscript assigned.

Change the value in the 'LoginscriptName.bat' field


#>




get-ADUser -filter "scriptpath -eq 'spitex.bat'" -Properties scriptpath | select name, samaccountname, scriptpath | Export-Csv -Path \\netapp01\daten\03_IT\CSVExport\Spitex_LoginScript_Users.csv -Encoding UTF8