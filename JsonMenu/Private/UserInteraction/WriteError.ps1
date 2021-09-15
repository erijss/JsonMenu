function JsonMenu.UserInteraction.WriteError {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    .NOTES
    #>
    [CmdletBinding()]
    param (
        $RaisedError
    )

    process {
        # if ($RaisedError -and (($RaisedError | Get-Member | Select-Object -ExpandProperty TypeName -Unique) -eq 'System.Management.Automation.ErrorRecord')) {

        #     Write-Host "Error information:"
        #     Write-Host "Exception type for catch: [$($RaisedError.Exception | Get-Member | Select-Object -ExpandProperty TypeName -Unique)]"

        #     if ($incomingError.InvocationInfo.Line) {

        #         Write-Host "Command : [$($RaisedError.InvocationInfo.Line.Trim())]"

        #     }
        #     else {
        #         Write-Host "Unable to get command information! Multiple catch blocks can do this :("
        #     }

        #     Write-Host "Exception: [$($RaisedError.Exception.Message)]"
        #     Write-Host "Target Object: [$($RaisedError.TargetObject)]"

        # }
        # else {
        #     Write-Host "Please include a valid error record when using this function!" -ForegroundColor Red -BackgroundColor DarkBlue
        # }
        $RaisedError
    }
}