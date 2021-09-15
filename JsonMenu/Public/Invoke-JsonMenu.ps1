function Invoke-JsonMenu {
    <#
    .SYNOPSIS
        Invoke the Json menu definition to run a menu in the console or as a system tray menu
    .DESCRIPTION
        Invoke-Menu creates a menu based on structured Json format. The Json contains definitions for menu optinos
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Input (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    [CmdletBinding(DefaultParameterSetName = 'Object')]
    param (
        # A converted JsonMenu json definition
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = "Object",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The JsonMenu input object.")]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $JsonMenu,

        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = "Path",
            HelpMessage = "Path to a JsonMenu json file.")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string]
        $Path,

        # Specifies a path to one or more locations.
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = "Json",
            HelpMessage = "A JsonMenu json definition.")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Json,

        # Specifies if the function is only validating the input.
        [Parameter(
            Position = 1,
            HelpMessage = "Use load the menu as a systray menu.")]
        [Switch]
        $AsSysTrayMenu
    )
    begin {
        Clear-Host

        switch ( $PSCmdLet.ParameterSetName ) {
            "Path" {
                try {
                    $jsonMenuContext.Configuration = Get-Content -Path $Path  -Force -Raw | ConvertFrom-Json
                   break
                }
                catch {
                    JsonMenu.UserInteraction.WriteError -RaisedError $_
                }
            }
            "Json" {
                try {
                    $jsonMenuContext.Configuration = $Json | ConvertFrom-Json
                    break
                }
                catch {
                    JsonMenu.UserInteraction.WriteError -RaisedError $_
                }
            }
            "Object" {
                try {
                    $jsonMenuContext.Configuration = $JsonMenu
                    break
                }
                catch {
                    JsonMenu.UserInteraction.WriteError -RaisedError $_
                }
            }
        }

        JsonMenu.Validation.ValidateConfiguration
    }

    process {
        JsonMenu.UserInteraction.WriteLogo

        $menuType = "Console"
        if ( $jsonMenuContext.Settings.MenuType ) {
           $menuType = $jsonMenuContext.Settings.MenuType
        } else {
            $menuType = $jsonMenuContext.Constants.Settings.MenuType
        }

        if ( $jsonMenuContext.Settings.StartMenu ) {
            $startMenu = $jsonMenuContext.Settings.StartMenu
        }
        else {
            $startMenu = $jsonMenuContext.Constants.Settings.StartMenu
        }

        if ( $menuType.ToLower() -eq "systray" -or $AsSysTrayMenu){
            JsonMenu.SysTrayMenu.WriteMenu -MenuId $startMenu
        }
        else {
            JsonMenu.ConsoleMenu.WriteMenu -MenuId $startMenu
        }
    }

    end {
        JsonMenu.UserInteraction.ClearHost -Cls $true
    }
}
