function JsonMenu.ConsoleMenu.WriteMenu {
    <#
    .SYNOPSIS
        Writes a menu to the output, wait for input and handle the selection
    .DESCRIPTION
        The steps are:
        - Clear selection, actiontype and action name
        - Get the menu based on the MenuId parameter
        - Write the menu header
        - Write the menu options
        - Write the selection statement and wait for input
        - When user input is received, validate of input matches an
          opton in the displayed menu
        - Do until the selection option is of type "exit"
    .EXAMPLE
        And example of a menu entry
        {
			"name": "main",
			"cls": true,
			"header": "Main menu",
			"options": [
				{
					"id": "1",
					"value": "Submenu",
					"type": "menu",
					"action": "menu1"
				},
				{
					"id": "2",
					"value": "execute script method",
					"type": "action",
					"action": "execute-script-method"
				},
				{
					"id": "q",
					"value": "Exit the menu",
					"type": "exit"
				}
			],
			"selection": {
				"prompt": "Select an option"
			}
		}
    .INPUTS
        [String]    MenuId
    .OUTPUTS
        none
    .NOTES
        none
    #>
    param (
        [Parameter()]
        [String]
        $MenuId
    )

    begin {
        $menu = $jsonMenuContext.Menus[$MenuId]
        $selection = $null
        $actionType = $null
        $actionId = $null
    }

    process {
        do {
            # invoke option if there is a valid actiontype and actionId
            if ( ($null -ne $actionType) -and ( $null -ne $actionId ) ) {
                JsonMenu.ConsoleMenu.InvokeOption -ActionType $actionType -ActionId $actionId -ActionName $actionName
            }

            $selection = $null
            $actionType = $null
            $actionId = $null

            # clear host
            JsonMenu.UserInteraction.ClearHost -Cls $menu.Cls

            # write header
            $headerOptions = @{
                Header = $menu.Header
                AddLineBreakBefore = (-not $menu.Cls)
                AddLineBreakAfter = $true
            }
            JsonMenu.UserInteraction.WriteHeader @headerOptions

            #write options
            JsonMenu.ConsoleMenu.WriteOptions -Options $menu.Options

            # write selection and wait for user input
            $selection = JsonMenu.UserInteraction.WriteSelection -Selection $menu.Selection -AddLineBreakBefore $true

            # validate userinput against current menu
            if ( ($selection -ne -1) -and $selection -ne "" ) {
                foreach ( $option in $menu.Options ) {
                    if ($option.id -eq $selection) {
                        $actionType = $option.type
                        $actionId = $option.action
                        $actionName = $option.value
                        break
                    }
                }
            }
        } until ( $actionType -eq $jsonMenuContext.Constants.Menu.ExitType )
    }
}