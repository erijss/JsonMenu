function JsonMenu.SysTrayMenu.InvokeOption {
    <#
    .SYNOPSIS
    .DESCRIPTION
    #>
    param (
        [String]
        $ActionId
    )

    process {

        # if ( $JsonMenu.Constants.Settings.ConsoleIsMinimizable -eq $true ) {
        #     JsonMenu.SysTrayMenu.ShowConsole
        # }

        JsonMenu.Action.WriteAction -ActionId $ActionId

        # if ( $JsonMenu.Constants.Settings.ConsoleIsMinimizable -eq $true ) {
        #     JsonMenu.SysTrayMenu.HideConsole
        # }
    }

}
