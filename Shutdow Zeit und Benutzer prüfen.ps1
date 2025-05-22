

get-winevent -LogName System -FilterXPath 'Event[System[EventID=1074 and Provider[@EventSourceName="User32"]]]' | sort TimeCreated -Desc | Select-Object -First 1  