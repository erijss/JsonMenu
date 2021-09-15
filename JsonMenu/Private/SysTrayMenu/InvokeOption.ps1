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

        # if ( $jsonMenuContext.Constants.Settings.ConsoleIsMinimizable -eq $true ) {
        #     JsonMenu.SysTrayMenu.ShowConsole
        # }

        JsonMenu.Action.WriteAction -ActionId $ActionId

        # if ( $jsonMenuContext.Constants.Settings.ConsoleIsMinimizable -eq $true ) {
        #     JsonMenu.SysTrayMenu.HideConsole
        # }
    }

}