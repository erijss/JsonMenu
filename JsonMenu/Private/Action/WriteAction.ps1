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
    [CmdletBinding()]
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
        $ActionContext = $JsonMenu.Context.Actions[$ActionId]

        if (($null -ne $ActionContext) -or ($ActionId -eq "")) {
            # we have a valid action to proceed

            # Extend ActionContext object with Succes, Stopwatch and Name if not yet present
            if ( $ActionContext.Success ) {
                $ActionContext.Success = $false
            }
            else {
                $ActionContext | Add-Member -MemberType NoteProperty -Name 'Success' -Value $false -Force
            }

            if ( $ActionContext.StopWatch ) {
                $ActionContext.StopWatch = $null
            }
            else {
                $ActionContext | Add-Member -MemberType NoteProperty -Name 'StopWatch' -Value $null -Force
            }

            if ( $ActionContext.Name ) {
            }
            else {
                $ActionContext | Add-Member -MemberType NoteProperty -Name 'Name' -Value $ActionName -Force
            }

            # Ensure we can continue if there is no action begin
            $continue = $true

            # write action begin, catch result as valdiation to continue or not
            if ( $ActionContext.Begin ) {
                $continue = JsonMenu.Action.WriteActionStart -Begin $ActionContext.Begin
            }

            if ( $continue -eq $true ) {
                # invoke action
                if ( $ActionContext.Invoke ) {
                    JsonMenu.Action.InvokeAction -Invoke $ActionContext.Invoke
                }

                # write action end
                if ( $ActionContext.End ) {
                    JsonMenu.Action.WriteActionEnd -End $ActionContext.End
                }
            }

            $JsonMenu.Context.Actions[$ActionId] = $ActionContext
        }
        else {
           #Not a valid action, so return
        }
    }
}
