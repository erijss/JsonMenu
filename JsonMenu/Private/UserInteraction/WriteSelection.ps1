function JsonMenu.UserInteraction.WriteSelection {
    <#
    .SYNOPSIS
        Write the selection object
    .DESCRIPTION
        The steps are:
        - Write a line to read the userinput
        - If anykey then it does not matter which key is entered
    .EXAMPLE
        "selection": {
            "prompt": "Press any key to continue",
            "anykey": true
        }
    .INPUTS
        [PSObject]  $Selection
        [Bool]      $AddLineBreakBefore
    .OUTPUTS
        none
    .NOTES
    #>
    param (
        [Parameter()]
        [PSObject]
        $Selection,
        [Parameter()]
        [Bool]
        $AddLineBreakBefore = $false
    )

    process {
        if ( -not $Selection.AnyKey -and $JsonMenu.Info.ConsoleIsMinimizable ) {
            if ( $Selection.Prompt ) {
                $prompt = $Selection.Prompt | JsonMenu.Functions.Expand
            }
            else {
                $prompt = $JsonMenu.Context.Settings.Selection.PromptForChoice | JsonMenu.Functions.Expand
            }

            if ( $AddLineBreakBefore ) {
                $prompt = "`n" + $prompt
            }

            return Read-Host -Prompt $prompt
        }
        elseif ( $JsonMenu.Info.ConsoleIsMinimizable ) {
            if ( $Selection.Prompt ) {
                $prompt = $Selection.Prompt | JsonMenu.Functions.Expand
            }
            else {
                $prompt = $JsonMenu.Context.Settings.Selection.PromptForAnyKey | JsonMenu.Functions.Expand
            }

            if ( $AddLineBreakBefore ) {
                $prompt = "`n" + $prompt
            }

            if ( $psISE ) {
                $null = Read-Host -Prompt $prompt
            }
            else {
                Write-Host $prompt
                $null = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
        }
    }

}
