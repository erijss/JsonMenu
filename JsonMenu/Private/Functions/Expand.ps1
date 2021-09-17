function JsonMenu.Functions.Expand {
    <#
    .SYNOPSIS
        Expands all the variables in a string or executes the script is the string starts and ends with curly brackets
    .DESCRIPTION
        In the context of the running application, there are a lot of variables set.
        this function replaces all the referenced context variables in a string with
        their actual value.

        The function is a recursive function that recursivly loop till it finds a string.
        This string is expanded for the possible variables that are in the string
    .EXAMPLE
        $MyWisdom = "Hello World"

        $json = @{
            {
                "WhatAWiseManOnceSaid": "I said: $MyWisdom"
            }
        }

        $wisdom = $json | Convert-FromJson

        Write-Output $wisdom.WhatAWiseManOnceSaid | JsonMenu.Functions.Expand
    .INPUTS
        [PSCustomObject]    $strubg
    .OUTPUTS
        [string]
    .NOTES
        Articles (and therefor credits) that helped me on this are
        - https://www.ais.com/expanding-variable-strings-in-powershell/
        - https://nerdymishka.com/articles/expand-string-in-powershell/
    #>
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $InputObject
    )

    process
    {
        # return nothing if there is no input
        if ($null -eq $InputObject) { return $null }

        if ( $InputObject.StartsWith("{") -and $InputObject.EndsWith("}") ) {
            # remove brackets
            $script = $InputObject.Substring(1,$InputObject.Length -2)
            # convert to scriptblock
            $scriptBlock = [ScriptBlock]::Create($script)
            # execute scriptblock
            & $scriptBlock
        }
        else {
            $ExecutionContext.InvokeCommand.ExpandString($InputObject)
        }
    }
}
