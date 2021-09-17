function JsonMenu.Action.LoadModule {
    <#
    .SYNOPSIS
        Loads a PowerShell module
    .DESCRIPTION
    .EXAMPLE
    .INPUTS
    .OUTPUTS
    .NOTES
    #>
    param (
        [Parameter()]
        [PSObject]
        $Module
    )
    process {
        $moduleName = $Module.Name | JsonMenu.Functions.Expand

        if ( $Module.Parameters ) {
            $moduleParameters = $Module.Parameters | JsonMenu.Action.SplatParameters
        }

        if ( $null -eq $moduleParameters ) {
            # Import-Module -Name $moduleName -Force
            . $moduleName
        }
        else {
            # Import-Module -Name $moduleName @moduleParameters -Force
            . $moduleName
        }
    }
}
