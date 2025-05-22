
<#


 IP 6 Operations on Client. 
 
 At the end reboot for this to take effect.


#>


# Disable IPv6 Globally: Use the following PowerShell command to disable IPv6 for all network adapters on your system:


New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value 0xFF -PropertyType DWord


# If you want to disable IPv6 only on a specific network adapter, use this command to list all adapters:

Get-NetAdapterBinding -ComponentID ms_tcpip6


# This command shows whether IPv6 is enabled on each adapter. To disable it on a specific adapter, use:

Disable-NetAdapterBinding -Name "AdapterName" -ComponentID ms_tcpip6


# If you need to re-enable IPv6 later, set the DisabledComponents value back to 0:

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value 0

