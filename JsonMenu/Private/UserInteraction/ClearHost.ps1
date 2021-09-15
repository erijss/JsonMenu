function JsonMenu.UserInteraction.ClearHost {
    <#
    .SYNOPSIS
        Clears the host
    .DESCRIPTION
        If Cls parameter is true clear host
    .EXAMPLE
        none
    .INPUTS
        $Cls
    .OUTPUTS
        none
    .NOTES
        none
    #>
    param (
        [Parameter()]
        [PSObject]
        $Cls
    )

    process {
        if ([bool]$Cls) {
            Clear-Host
        }
    }
}