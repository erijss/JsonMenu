[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Name
)

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$stopwatch.Start()

Write-Output "Beginning of action that takes some time!"
Write-Output "First wait 2 seconds"
Start-Sleep 2
Write-Output $("Important information you would rather not have to wait for, $Name!")
Write-Output "Now wait another 2 seconds"
Get-Process | Format-Table
Start-Sleep 2
Write-Output "Operation finished!"

$stopwatch.Stop()

Write-Output "That was another $([math]::Round($stopwatch.Elapsed.TotalMilliseconds)) milliseconds of your life ;-)"

$ActionResult = "Some time consuming action has been executed"
return $ActionResult
