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
    param (
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $Parameters
    )
    process {
        if ( $Parameters ) {
            $splattedParameters = @{}

            foreach ($parameter in $Parameters.PSObject.Properties)
            {
                $value = $parameter.Value #| JsonMenu.Functionss.Expand
                # expanding on parameters is disabled because
                # $True becomes True for Boolean values
                # Is there really a need for this. Maybe a little bit overdone

                $splattedParameters.Add($parameter.Name, $value)
            }

            return $splattedParameters
        }
    }
}
