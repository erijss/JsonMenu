function JsonMenu.Functions.ResolveContextVariables {
    <#
    .SYNOPSIS
        Expands all the variables in custom object
    .DESCRIPTION
        In the context of the running application, there are a lot of variables set.
        this function replaces all the referenced variables in a custom object with
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

        $wisdom = $json | Convert-FromJson | ResolveContextVAriables

        Write-Output $wisdom.WhatAWiseManOnceSaid
    .INPUTS
        [PSCustomObject]    $InputObject
    .OUTPUTS
        [PSCustomObject]
    .NOTES
        Articles (and therefor credits) that helped me on this are
        - https://www.ais.com/expanding-variable-strings-in-powershell/
        - https://nerdymishka.com/articles/expand-string-in-powershell/
    #>
    param (
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $InputObject
    )

    process
    {
        # return nothing if there is no input
        if ($null -eq $InputObject) { return $null }

        # recursive on nested objects
        if ( $InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string] ) {
            for ($i = 0; $i -lt $InputObject.Length; $i++) {
                $InputObject[$i] = JsonMenu.Functions.ResolveContextVariables $InputObject[$i]
            }
        }
        # recursive on the objects properties
        elseif ( $InputObject -is [pscustomobject] -and $InputObject -isnot [string] ) {
            foreach ($property in $InputObject.PSObject.Properties) {
                if ($property -is [psnoteproperty] ) {
                    $property.value = JsonMenu.Functions.ResolveContextVariables $property.value
                }
            }
        }
        # expand the string with the variables
        else
        {
            return $ExecutionContext.InvokeCommand.ExpandString($InputObject)
        }

        # return the object
        $InputObject
    }
}
