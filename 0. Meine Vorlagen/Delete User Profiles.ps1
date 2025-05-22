

PS C:\> Get-CimInstance -ClassName win32_userprofile | Select-Object -First 1


PS C:\> Get-CimInstance -ClassName Win32_UserProfile -ComputerName localhost,WINSRV


Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq 'UserA' } | Remove-CimInstance



Get-CimInstance -ComputerName SRV1,SRV2,SRV3 -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq 'UserA' } | Remove-CimInstance