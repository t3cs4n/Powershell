if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}

function Test-TLS1_2 {
  try {
    Invoke-RestMethod -Method Get -Uri 'https://api2.lifestage-solutions.ch' -ErrorAction Stop
  }
  catch [System.Net.WebException] {
    if ($_.Exception.Response.StatusCode.Value__ -eq 403) {
      return $true
    }
    if ($_.Exception.SecureChannelFailure -eq 'SecureChannelFailure') {
      return $false
    }
  }
  catch {
    Write-Error 'Error! Could not contact Lifestage API for unknown reasons. Error:'
    Write-Output $_.Exception
  }
}

function Import-RegFile {
  param(
    [string]$FilePath
  )

  $startprocessParams = @{
    FilePath     = "$Env:SystemRoot\REGEDIT.exe"
    ArgumentList = '/s', $FilePath
    Verb         = 'RunAs'
    PassThru     = $true
    Wait         = $true
  }
  $proc = Start-Process @startprocessParams

  if ($proc.ExitCode -eq 0) {
    Write-Host 'Success! Please restart the Computer for the changes to take effect.' -ForegroundColor Yellow
  }
  else {
    Write-Error "Error! Could not import reg File. Error code: $($Proc.ExitCode)"
  }
}

if (-not(Test-TLS1_2)) {
  Write-Host 'TLS 1.2 is NOT active on this system. Setting registry' -ForegroundColor Red
  Import-RegFile -FilePath "$PSSCriptRoot\EnableTLS1_2.reg"
}
else {
  Write-Host 'TLS is active and enabled. No need to take action.' -ForegroundColor Green
}

Write-Host 'Press any key to continue...'
$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')