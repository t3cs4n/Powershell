<#

Autor : Miguel Santiago

Dieses Script kannst du nutzen um mehrere Benutzer der Gruppe Lizenz_Microsoft_365_Business_Standard hinzuzufügen.
Liste dazu die betroffenen Benutzer nach dem -Members auf. Siehe Beispiel in Zeile 8

Add-ADGroupMember -Identity Lizenz_Microsoft_365_Business_Standard -Members sami, tsra, heca usw


#>



Add-ADGroupMember -Identity Lizenz_Microsoft_365_Business_Basic -Members tsadminoffice,tsadminoffice_2,tsadminoffice_3,tsadminoffice_4,tsadminoffice_5