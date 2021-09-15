function JsonMenu.ConsoleMenu.InvokeOption {
    <#
    .SYNOPSIS
        Executes the selected option
    .DESCRIPTION
        The steps are:
        - determine the actiontype, e.g. menu or action
        - In case of a menu, write the menu
        - In case of an action, write the action
        - in case of undetermined, do nothing

        The parameter ActionType can be either "menu" or "action"
        The ActionId is referring to the action object in the actions array with that key
    .EXAMPLE
        The otpion block looks like:
        {
            "id": "1",
            "value": "Submenu",
            "type": "menu",
            "action": "menu1"
        }
    .INPUTS
        [String]    ActionType
        [String]    ActionId
        [String]    ActionName
    .OUTPUTS
        none
    .NOTES
        none
    #>
    param (
        [Parameter()]
        [String]
        $ActionType,
        [Parameter()]
        [String]
        $ActionId,
        [Parameter()]
        [String]
        $ActionName
    )

    process {
        switch ($ActionType) {
            # write menu
            $jsonMenuContext.Constants.Menu.MenuType {
                JsonMenu.ConsoleMenu.WriteMenu -MenuId $ActionId
                break
             }
            #  write action
             $jsonMenuContext.Constants.Menu.ActionType {
                JsonMenu.Action.WriteAction -ActionId $ActionId -ActionName $ActionName
                break
            }
        }
    }

}