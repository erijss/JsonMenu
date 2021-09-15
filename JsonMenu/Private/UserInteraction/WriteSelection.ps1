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
        if ( -not $Selection.AnyKey -and $jsonMenuContext.Constants.Settings.ConsoleIsMinimizable ) {
            if ( $Selection.Prompt ) {
                $prompt = $Selection.Prompt | JsonMenu.Functions.ResolveContextVariables
            }
            elseif ( $jsonMenuContext.Settings.Selection.PromptForChoice ) {
                $prompt =  $jsonMenuContext.Settings.Selection.PromptForChoice | JsonMenu.Functions.ResolveContextVariables
            }
            else {
                $prompt =  $jsonMenuContext.Constants.Selection.PromptForChoice
            }

            if ( $AddLineBreakBefore ) {
                $prompt = "`n" + $prompt
            }

            return Read-Host -Prompt $prompt
        }
        elseif ( $jsonMenuContext.Constants.Settings.ConsoleIsMinimizable ) {
            if ( $Selection.Prompt ) {
                $prompt = $Selection.Prompt | JsonMenu.Functions.ResolveContextVariables
            }
            elseif ( $jsonMenuContext.Settings.Selection.PromptForAnyKey ) {
                $prompt = $jsonMenuContext.Settings.Selection.PromptForAnyKey | JsonMenu.Functions.ResolveContextVariables
            }
            else {
                $prompt =  $jsonMenuContext.Constants.Selection.PromptForAnyKey
            }

            if ( $AddLineBreakBefore ) {
                $prompt = "`n" + $prompt
            }

            if ( $psISE ) {
                $null = Read-Host -Prompt $prompt
            }
            else {
                Write-Output $prompt
                $null = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
        }
    }

}