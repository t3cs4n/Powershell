# Konvertierung einer Datei in UTF-8

<#

Warum UTF-8?
UTF-8 ist eine universelle Zeichenkodierung, die nahezu alle Zeichen der Welt darstellen kann, einschließlich Umlaute und anderer Sonderzeichen. In PowerShell ist es oft notwendig, Dateien oder Zeichenketten in UTF-8 zu konvertieren, um eine korrekte Darstellung und Verarbeitung zu gewährleisten.

Grundlegendes Skript zur Konvertierung einer Datei in UTF-8:

#>


# Datei, die konvertiert werden soll
$datei = "C:\Pfad\zu\deiner\Datei.txt"

# Inhalt der Datei lesen und in UTF-8 codieren
$inhalt = Get-Content $datei -Encoding utf8

# Inhalt in einer neuen Datei speichern (auch als UTF-8)
Set-Content "C:\Pfad\zu\neuer\Datei.txt" -Value $inhalt -Encoding utf8