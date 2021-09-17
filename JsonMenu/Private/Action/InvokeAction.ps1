function JsonMenu.Action.InvokeAction {
    <#
    .SYNOPSIS
        executes the "invoke" object from the "action" object in the json menu definition
    .DESCRIPTION
        The steps are:
        - clear screen if required
        - load module from path, if required
        - execute a metod
        - unload module, if required TODO
    .EXAMPLE
        The input is the invoke portion from an action:

        invoke": {
            "cls": true,
            "module": {
                    "name": ""
                    "parameters": {}
                    "unload": true
            },
            "method": {
                    "name": "",
                    "parameters": {}
            }
        }
    .INPUTS
       [PSObject]    Invoke
    .OUTPUTS
        none
    .NOTES
    #>
    param (
        [Parameter()]
        [PSObject]
        $Invoke
    )
    process {

        # clear host otherwise add a new line
        if ( $Invoke.Cls ) {
            JsonMenu.UserInteraction.ClearHost -Cls $Invoke.Cls
        }
        else {
            Write-Output " "
        }

        $actionContextStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $actionContextStopwatch.Start()

        if ( $Invoke.Module ) {
            $moduleName = $Invoke.Module.Name| JsonMenu.Functions.Expand

            if ( $Invoke.Module.Parameters ) {
                $moduleParameters = $Invoke.Module.Parameters | JsonMenu.Action.SplatParameters
            }

            if ( $null -eq $moduleParameters ) {
                Import-Module -Name $moduleName -Force
            }
            else {
                Import-Module -Name $moduleName @moduleParameters -Force
            }

            # JsonMenu.Action.LoadModule -Module $Invoke.Module
            # The function JsonMenu.Action.LoadModule contains exact the same code
            # as this if block. However, if the module is loaded in a separate function,
            # the method is not recognized.
            # "inline loading" does work, though. Why?
        }

        if ( $Invoke.Method) {
            JsonMenu.Action.CallMethod -Method $Invoke.Method
        }

        $actionContextStopwatch.Stop()
        $ActionContext.Stopwatch = $actionStopwatch
    }
}
