function JsonMenu.Action.SplatParameters {
    <#
    .SYNOPSIS
        Splats the Parameters into a hashtable
    .DESCRIPTION
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        [PSObject]
        $Parameters
    )
    process {
        $splattedParameters = @{}

        foreach ($parameter in $Parameters) {
            # expanding on parameters is disabled because
            # $True becomes True for Boolean values
            # Is there really a need for this. Maybe a little bit overdone
            if ( $parameter -is [string] ) {
                $name = $parameter
                $value = $null
            }
            else {
                $name = $parameter.PSObject.Properties.Name
                $value = $parameter.PSObject.Properties.Value
            }
            $splattedParameters.Add($name, $value)
        }

        return $splattedParameters
    }
}
