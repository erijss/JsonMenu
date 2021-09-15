function JsonMenu.UserInteraction.WriteConfirmation {
    <#
    .SYNOPSIS
        Write a choice to confirm or cancel an action
    .DESCRIPTION
        This function gives a user the choice to confirm or to cancel
        the action
    .EXAMPLE
        The input for the confirmation it this Json:

        "confirmation" : {
            "question": "Do you want to continue?",
            "continue": {
                "label": "&Yes",
                "help": "Click 'Y' to continue"
            },
            "cancel": {
                "label": "&No",
                "help": "Click 'N' to cancel"
            }
        }


    .INPUTS
        [PSObject]  Confirmation
        [Bool]      AddLineBreakBefore
    .OUTPUTS
        $true or $false
    .NOTES
        The AddLineBreakBefore is Boolean in stead of Switch on purpose
    #>
    [OutputType([Boolean])]
    param (
        [Parameter()]
        [PSObject]
        $Confirmation,
        [Parameter()]
        [Bool]
        $AddLineBreakBefore = $false
    )

    process {
        if ( $Confirmation ) {
            # Get question value
            if ( $Confirmation.Question ) {
                $question = $Confirmation.Question | JsonMenu.Functions.ResolveContextVariables
            }
            elseif ( $jsonMenuContext.Settings.Confirmation.Question ) {
                $question = $jsonMenuContext.Settings.Confirmation.Question | JsonMenu.Functions.ResolveContextVariables
            }
            else {
                $question = $jsonMenuContext.Constants.Confirmation.Question
            }

            # Get confirmation label and help
            if ( $Confirmation.Continue ) {
                # defined inline
                # label
                if ( $Confirmation.Continue.Label ) {
                    $continueLabel = $Confirmation.Continue.Label | JsonMenu.Functions.ResolveContextVariables
                }
                elseif ( $jsonMenuContext.Settings.Confirmation.Continue.Label ) {
                    $continueLabel = $jsonMenuContext.Settings.Confirmation.Continue.Label | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $continueLabel = $jsonMenuContext.Constants.Confirmation.Continue.Label
                }
                # help
                if ( $Confirmation.Continue.Help ) {
                    $continueHelp = $Confirmation.Continue.Help | JsonMenu.Functions.ResolveContextVariables
                }
                elseif ( $jsonMenuContext.Settings.Confirmation.ContinueHelp ) {
                    $continueHelp = $jsonMenuContext.Settings.Confirmation.Continue.Help | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $continueLabel = $jsonMenuContext.Constants.Confirmation.Continue.Help
                }
            }
            elseif ( $jsonMenuContext.Settings.Confirmation.Continue ) {
                # settings
                # label
                if ( $jsonMenuContext.Settings.Confirmation.Continue.Label ) {
                    $continueLabel = $jsonMenuContext.Settings.Confirmation.Continue.Label | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $continueLabel = $jsonMenuContext.Constants.Confirmation.Continue.Label
                }
                # help
                if ( $jsonMenuContext.Settings.Confirmation.Continue.Help ) {
                    $continueHelp = $jsonMenuContext.Settings.Confirmation.Continue.Help | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $continueHelp = $jsonMenuContext.Constants.Confirmation.Continue.Help
                }
            }
            else {
                # constants
                $continueLabel = $jsonMenuContext.Constants.Confirmation.Continue.Label
                $continueHelp = $jsonMenuContext.Constants.Confirmation.Continue.Help
            }

            # Get cancel label and help
            if ( $Confirmation.Cancel ) {
                # defined inline
                # label
                if ( $Confirmation.Cancel.Label ) {
                    $cancelLabel = $Confirmation.Cancel.Label | JsonMenu.Functions.ResolveContextVariables
                }
                elseif ( $jsonMenuContext.Settings.Confirmation.Cancel.Label ) {
                    $cancelLabel = $jsonMenuContext.Settings.Confirmation.Cancel.Label | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $cancelLabel = $jsonMenuContext.Constants.Confirmation.Cancel.Label
                }
                # help
                if ( $Confirmation.Cancel.Help ) {
                    $cancelHelp = $Confirmation.Cancel.Help | JsonMenu.Functions.ResolveContextVariables
                }
                elseif ( $jsonMenuContext.Settings.Confirmation.Cancel.Help ) {
                    $cancelHelp = $jsonMenuContext.Settings.Confirmation.Cancel.Help | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $cancelHelp = $jsonMenuContext.Constants.Confirmation.Cancel.Help
                }
            }
            elseif ( $jsonMenuContext.Settings.Confirmation.Cancel ) {
                # settings
                # label
                if ( $jsonMenuContext.Settings.Confirmation.Cancel.Label ) {
                    $cancelLabel = $jsonMenuContext.Settings.Confirmation.Cancel.Label | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $cancelLabel = $jsonMenuContext.Constants.Confirmation.Cancel.Label
                }
                # help
                if ( $jsonMenuContext.Settings.Confirmation.Cancel.Help ) {
                    $cancelHelp = $jsonMenuContext.Settings.Confirmation.Cancel.Help | JsonMenu.Functions.ResolveContextVariables
                }
                else {
                    $cancelHelp = $jsonMenuContext.Constants.Confirmation.Cancel.Help
                }
            }
            else {
                $cancelLabel = $jsonMenuContext.Constants.Confirmation.Cancel.Label
                $cancelHelp = $jsonMenuContext.Constants.Confirmation.Cancel.Help
            }

            # setup choices
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList $continueLabel, $continueHelp))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList $cancelLabel, $cancelHelp))

            # handle linebreak
            if ( $AddLineBreakBefore ) {
                Write-Output " "
            }

            # prompt for choice and wait for user input
            $decision = $Host.UI.PromptForChoice($question, $null, $choices, -1)

            # return user input
            if ($decision -eq 0) {
                return $true
            }
            else {
                return $false
            }
        }
    }
}