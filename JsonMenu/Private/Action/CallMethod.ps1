function JsonMenu.Action.CallMethod {
    <#
    .SYNOPSIS
        Calls a method
    .DESCRIPTION
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    .NOTES
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [PSObject]
        $Method
    )

    process {
        $methodName = $Method.Name | JsonMenu.Functions.Expand

        if ( $Method.Parameters ) {
            $methodParameters = JsonMenu.Action.SplatParameters -Parameters $Method.Parameters
        }
        else {
            # No parameters to process
        }

        try {
            if ( $null -eq $methodParameters ) {
                & $methodName -ErrorAction $JsonMenu.Context.Settings.Action.ErrorAction
                $ActionContext.Success = $true
            }
            else {
                & $methodName @methodParameters -ErrorAction $JsonMenu.Context.Settings.Action.ErrorAction
                $ActionContext.Success = $true
            }
        }
        catch {
            JsonMenu.UserInteraction.WriteError -RaisedError $_
            $ActionContext.Success = $false
        }
    }
}
