function JsonMenu.Action.WriteActionStart {
    <#
    .SYNOPSIS
        Writes the first step of an action
    .DESCRIPTION
        The steps are:
        - Check if screen should be cleared
        - Write header
        - Write confirmation, if required

        The fuction returns true or false based on the confirmation.
        The default return value is $true
    .EXAMPLE
        The input is the begin object from an action:

        "begin": {
            "cls": true/false,
            "header": [],
            "confirmation" : {}
        }
    .INPUTS
        [PSObject]  Begin
    .OUTPUTS
        [Boolean] $true (default) or $false
    .NOTES
        none
    #>
    param (
        [Parameter()]
        [PSObject]
        $Begin
    )

    process {

        if ( $Begin ) {
            if ( $Begin.Cls ) {
                JsonMenu.UserInteraction.ClearHost -Cls $Begin.Cls
            }

            if ( $Begin.Header ) {
                $headerOptions = @{
                    Header = $Begin.Header
                    AddLineBreakBefore = (-not $Begin.Cls)
                    AddLineBreakAfter = $false
                }
                JsonMenu.UserInteraction.WriteHeader @headerOptions
            }
        }
    }
}
