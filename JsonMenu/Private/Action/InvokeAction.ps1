function JsonMenu.Action.InvokeAction {
    <#
    .SYNOPSIS
        executes the "invoke" object from the "action" object in the json menu definition
    .DESCRIPTION
        The steps are:
        - clear screen if required
        - load module from path, if required
        - execute a metod
        - unload module, if required
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

        The actioncontext is returned with the parameters
        - Name     name of the action
        - Success  true or false
        - Result   Holds the output of the function
    .INPUTS
       [PSObject]    Invoke
    .OUTPUTS
        none
    .NOTES
        The biggest limition on the invocation of the actions is that, due to the
        Call operator (&), Write-Output in the called function is not displayed.
        Only return values are part of the output or all other ways to write (console, verbose, warning, etc.)

        A good explanation for that can be found here:
        https://stackoverflow.com/questions/52757670/why-does-write-output-not-work-inside-a-powershell-class-method

        In the answers of that article, a quirky solution is mentioned. However, this works stand-alone but
        not in this function. If the following example is run in a separate .ps1 file it works:

        $methodName = "D:\Code\JsonMenuProject_202108\Examples\HelloWorld.ps1"
        $methodParameters = @{
            Name = "John Doe"
        }

        class FunctionWrapper {
            static [ScriptBlock]Execute(){
                return { & $methodName @methodParameters };
            }
        }

        & $([FunctionWrapper]::Execute())

        The reason that is possibly that we are already in a nested function, so this approach should
        be applied to all levels.

        An alternative that is not investigated yet is the creation of a new PowerShell process or
        window to execute the function, method or script there.
    #>
    param (
        [Parameter()]
        [PSObject]
        $Invoke,
        [Parameter()]
        [String]
        $ActionId
    )
    process {

        # clear host otherwise add a new line
        if ( $Invoke.Cls ) {
            JsonMenu.UserInteraction.ClearHost -Cls $Invoke.Cls
        }
        else {
            Write-Output " "
        }

        # moduule
        if ( $Invoke.Module ) {
            $moduleName = $Invoke.Module.Name| JsonMenu.Functions.Expand

            # resolve context variable and convert to hashtable
            $moduleParameters = @{}
            foreach ($parameter in $Invoke.Method.Parameters.PSObject.Properties)
            {
                $value = $parameter.Value | JsonMenu.Functions.Expand
                $moduleParameters.Add($parameter.Name, $value)
            }

            # load module
            if ( $null -eq $moduleParameters ) {
                Import-Module -Name $moduleName -Force
            }
            else {
                Import-Module -Name $moduleName @moduleParameters -Force
            }
        }

        # function
        if ( $Invoke.Method) {
            $methodName = $Invoke.Method.Name | JsonMenu.Functions.Expand

            # resolve context variable and convert to hashtable
            $methodParameters = @{}
            foreach ($parameter in $Invoke.Method.Parameters.PSObject.Properties)
            {
                $value = $parameter.Value | JsonMenu.Functions.Expand
                $methodParameters.Add($parameter.Name, $value)
            }

            $actionStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $actionStopwatch.Start()

            # execute function
            try {
                if ( $null -eq $methodParameters ) {
                    & $methodName
                    # $JsonMenu.Context.ActionResults[$ActionId] = $true
                    $ActionContext.Success = $true
                }
                else {
                    & $methodName @methodParameters
                    # $JsonMenu.Context.ActionResults[$ActionId] = $true
                    $ActionContext.Success = $true
                }
            }
            catch {
                Write-Error $_
                # $JsonMenu.Context.ActionResults[$ActionId] = $false
                $ActionContext.Success = $false
            }

            $actionStopwatch.Stop()
            $ActionContext.Stopwatch = $actionStopwatch
        }
    }
}
