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
    [CmdletBinding()]
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
            Write-Host " "
        }

        $actionContextStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $actionContextStopwatch.Start()

        if ( $Invoke.Script ) {
            # When loading a script with functions, it has to be loaded in the same
            # function as the invocation of the method in the script. This code cannot
            # be moved ina separate function, otherwise it will not work

            $scriptPath = $Invoke.Script.Path | JsonMenu.Functions.Expand

            if ( $Invoke.Script.Parameters ) {
                $scriptParameters = $Invoke.Script.Parameters | JsonMenu.Action.SplatParameters
            }

            try {
                if ( $null -eq $scriptParameters ) {
                    . $scriptPath -ErrorAction JsonMenu.Context.Settings.Action.ErrorAction
                    $ActionContext.Success = $true
                }
                else {
                    . $scriptPath @scriptParameters -ErrorAction JsonMenu.Context.Settings.Action.ErrorAction
                    $ActionContext.Success = $true
                }
            }
            catch {
                JsonMenu.UserInteraction.WriteError -RaisedError $
                $ActionContext.Success = $false
            }
        }

        if ( $Invoke.Module ) {
            JsonMenu.Action.LoadModule -Module $Invoke.Module
        }

        if ( $Invoke.Method) {
            JsonMenu.Action.CallMethod -Method $Invoke.Method
        }

        $actionContextStopwatch.Stop()
        $ActionContext.Stopwatch = $actionContextStopwatch
    }
}
