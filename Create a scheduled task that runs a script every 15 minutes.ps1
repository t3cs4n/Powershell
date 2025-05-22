<#


 Create a scheduled task that runs a script every 15 minutes


#>



# Define the script path (replace with your actual script location)
$scriptPath = "C:\Users\Public\Documents\powershell_scripts\move_contactfiles_abatoperi.ps1"

# Set the trigger to run every 15 minutes
$trigger = New-JobTrigger -Once -At "5/08/2024 1pm" -RepetitionInterval (New-TimeSpan -Minute 15) -RepetitionDuration ([TimeSpan]::MaxValue)

# Register the scheduled job
Register-ScheduledJob -Name "Move Contacts Aba to Peri" -ScriptBlock { & $scriptPath } -Trigger $trigger

