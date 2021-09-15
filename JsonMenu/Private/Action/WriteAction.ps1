function JsonMenu.Action.WriteAction {
    <#
    .SYNOPSIS
        Writes the substeps of an action
    .DESCRIPTION
        The steps are:
        - empty the jsonMenuContext.ActionContext. ActionContext holds the id, name, success and stopwatch of the action
        - begin: step to write an introduction and ask for a confirmation to continue
        - invoke: step to load a module (optional) and execute a method
        - end: step to summarize the action and display the action result
        - the final step is add the result of the action the JsonMenu context
    .EXAMPLE
        The input is the invoke object from an action:

         {
            "id": ""
            "name": "",
            "begin":{},
            "invoke":{},
            "end":{},
        }

    .INPUTS
        [String]    ActionId
        [String]    ActonName
    .OUTPUTS
        none
    .NOTES
        none
    #>
    param (
        [Parameter()]
        [String]
        $ActionId,
        [Parameter()]
        [String]
        $ActionName
    )
    process {
        # get action from Json menu data
        $action = $jsonMenuContext.Actions[$ActionId]

        if (($null -ne $action) -or ($ActionId -eq "")) {
            # we have a valid action to proceed

            # clear action result from previous attempt
            if ( $jsonMenuContext.ActionResults.ContainsKey($ActionId) ) {
                $jsonMenuContext.ActionResults[$ActionId] = $false
            }
            else {
                $jsonMenuContext.ActionResults[$ActionId] = $false
            }

            # create action context object
            if ( $action.Name ) {
                $ActionName = $action.Name
            }

            $jsonMenuContext.ActionContext = @{}
            $jsonMenuContext.ActionContext.Id = $ActionId
            $jsonMenuContext.ActionContext.Name = $ActionName
            $jsonMenuContext.ActionContext.Success = $false

            # Ensure we can continue if there is no action begin
            $continue = $true

            # write action begin, catch result as valdiation to continue or not
            if ( $action.Begin ) {
                $continue = JsonMenu.Action.WriteActionStart -Begin $action.Begin
            }

            if ( $continue -eq $true ) {
                # invoke action
                if ( $action.Invoke ) {
                    JsonMenu.Action.InvokeAction -Invoke $action.Invoke -ActionId $ActionId
                }

                # write action end
                if ( $action.End ) {
                    JsonMenu.Action.WriteActionEnd -End $action.End
                }
            }
        }
        else {
           #Not a valid action, so return
        }
    }
}