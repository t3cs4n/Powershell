# Ordner und Unterordner auslesen

Get-ChildItem \\netapp01\daten\03_IT -Recurse -Name -Directory | Out-GridView


Get-ChildItem \\netapp01\daten\03_IT -Recurse -Name -Directory | Out-File “C:\Temp\Struktur.csv”