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
                $question = $Confirmation.Question | JsonMenu.Functions.Expand
            }
            else {
                $question = $JsonMenu.Context.Settings.Confirmation.Question | JsonMenu.Functions.Expand
            }

            # Get confirmation label and help
            if ( $Confirmation.Continue ) {
                # defined inline
                # label
                if ( $Confirmation.Continue.Label ) {
                    $continueLabel = $Confirmation.Continue.Label | JsonMenu.Functions.Expand
                }
                else {
                    $continueLabel = $JsonMenu.Context.Settings.Confirmation.Continue.Label | JsonMenu.Functions.Expand
                }
                # help
                if ( $Confirmation.Continue.Help ) {
                    $continueHelp = $Confirmation.Continue.Help | JsonMenu.Functions.Expand
                }
                else {
                    $continueHelp = $JsonMenu.Context.Settings.Confirmation.Continue.Help | JsonMenu.Functions.Expand
                }
            }
            else {
                # defaults
                $continueLabel = $JsonMenu.Context.Settings.Confirmation.Continue.Label | JsonMenu.Functions.Expand
                $continueHelp = $JsonMenu.Context.Settings.Confirmation.Continue.Help | JsonMenu.Functions.Expand
            }

            # Get cancel label and help
            if ( $Confirmation.Cancel ) {
                # defined inline
                # label
                if ( $Confirmation.Cancel.Label ) {
                    $cancelLabel = $Confirmation.Cancel.Label | JsonMenu.Functions.Expand
                }
                else {
                    $cancelLabel = $JsonMenu.Context.Settings.Confirmation.Cancel.Label | JsonMenu.Functions.Expand
                }
                # help
                if ( $Confirmation.Cancel.Help ) {
                    $cancelHelp = $Confirmation.Cancel.Help | JsonMenu.Functions.Expand
                }
                else {
                    $cancelHelp = $JsonMenu.Context.Settings.Confirmation.Cancel.Help | JsonMenu.Functions.Expand
                }
            }
            else {
                $cancelLabel = $JsonMenu.Context.Settings.Confirmation.Cancel.Label
                $cancelHelp = $JsonMenu.Context.Settings.Confirmation.Cancel.Help
            }

            # setup choices
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList $continueLabel, $continueHelp))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList $cancelLabel, $cancelHelp))

            # handle linebreak
            if ( $AddLineBreakBefore ) {
                Write-Host " "
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
