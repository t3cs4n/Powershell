<#

 Powershell script for deleting files from a folder after 24h including all subfolders


#>



# Ändern Sie den Pfad zum zu bereinigenden Ordner
$targetFolder = "\\netapp01\daten\15_Temp\15.1_Scans"

# Berechne den Stichzeitpunkt für Dateien, die älter als 24 Stunden sind
$cutoffTime = (Get-Date).AddDays(-1)

# Durchsuche den Ordner rekursiv nach Dateien
$filesToDelete = Get-ChildItem -Path $targetFolder -Recurse -File

# Filtere Dateien, die älter als 24 Stunden sind
$filesToDelete = $filesToDelete | Where-Object { $_.CreationTime -lt $cutoffTime }

# Lösche die gefilterten Dateien
Write-Verbose "Lösche folgende Dateien:"
Write-Verbose $filesToDelete

# Aktivieren Sie die Zeile zum Löschen der Dateien. Entfernen Sie '-WhatIf' zum Löschen.
Remove-Item -Path $filesToDelete.FullName -Force #-WhatIf

