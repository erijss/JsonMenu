function JsonMenu.Action.WriteActionEnd {
    <#
    .SYNOPSIS
        Writes the last step of an action object
    .DESCRIPTION
        The steps are:
        - Check if screen should be cleared
        - Write header
        - Write selection, if required
    .EXAMPLE
        The input is the begin object from an action:

        "end": {
            "cls": false,
            "header": []],
            "selection": {
                "prompt": "",
                "anykey": true
            }
        }
    .INPUTS
        [PSObject]  End
    .OUTPUTS
        none
    .NOTES
        none
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [PSObject]
        $End
    )

    process {
        if ( $End ) {

            # clear host
            if ( $End.Cls ) {
                JsonMenu.UserInteraction.ClearHost -Cls $End.Cls
            }

            # write header
            if ( $End.Header ) {
                $headerOptions = @{
                    Header             = $End.Header
                    AddLineBreakBefore = (-not $End.Cls)
                    AddLineBreakAfter  = $false
                }
                JsonMenu.UserInteraction.WriteHeader @headerOptions
            }

            # write selection
            if ( $End.Selection ) {
                $selectionOptions = @{
                    Selection          = $End.Selection
                    AddLineBreakBefore = ($End.Header) -or (-not $End.Cls)
                }
                JsonMenu.UserInteraction.WriteSelection @selectionOptions
            }
        }
    }
}
