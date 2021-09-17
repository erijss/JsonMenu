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
        $Object,

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
                    $JsonMenu.Configuration = Get-Content -Path $Path  -Force -Raw | ConvertFrom-Json
                   break
                }
                catch {
                    JsonMenu.UserInteraction.WriteError -RaisedError $_
                }
            }
            "Json" {
                try {
                    $JsonMenu.Configuration = $Json | ConvertFrom-Json
                    break
                }
                catch {
                    JsonMenu.UserInteraction.WriteError -RaisedError $_
                }
            }
            "Object" {
                try {
                    $JsonMenu.Configuration = $Object
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
        if ( $JsonMenu.Context.Settings.MenuType ) {
           $menuType = $JsonMenu.Context.Settings.MenuType
        } else {
            $menuType = $JsonMenu.Constants.Settings.MenuType
        }

        if ( $JsonMenu.Context.Settings.StartMenu ) {
            $startMenu = $JsonMenu.Context.Settings.StartMenu
        }
        else {
            $startMenu = $JsonMenu.Constants.Settings.StartMenu
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
