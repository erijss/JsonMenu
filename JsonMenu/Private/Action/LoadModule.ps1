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
        $modulePath = $Module.Path | JsonMenu.Functions.Expand

        if ( $moduleName ) {
            $moduleToLoad = $moduleName
        }
        elseif ( $modulePath ) {
            $moduleToLoad = $modulePath
        }

        if ( $Module.Parameters ) {
            $moduleParameters = JsonMenu.Action.SplatParameters -Parameters $Module.Parameters
        }

        if ( $null -eq $moduleParameters ) {
            Import-Module -Name $moduleToLoad
        }
        else {
            Import-Module -Name $moduleToLoad @moduleParameters
        }
    }
}
