function JsonMenu.SysTrayMenu.WriteOptions {
    <#
    .SYNOPSIS
    .DESCRIPTION
    #>
    param (
        [Parameter()]
        [Object]
        $Container,
        [Parameter()]
        [PSCustomObject]
        $Options
    )
    process {

        foreach ($option in $Options) {
            switch ( $option.type ) {
                $JsonMenu.Constants.Menu.MenuType {
                    $menuItem = New-Object System.Windows.Forms.MenuItem
                    $menuItem.Text = $option.Value
                    $menuOptions = $JsonMenu.Context.Menus[$option.Action].Options
                    $menuItem = JsonMenu.SysTrayMenu.WriteOptions -Container $menuItem -Options $menuOptions
                    $Container.MenuItems.AddRange($menuItem)
                    break
                }
                $JsonMenu.Constants.Menu.ActionType {
                    $menuItem = New-Object System.Windows.Forms.MenuItem
                    $menuItem.Text = $option.Value
                    $menuItem.Name = $option.action
                    $menuItem.Add_Click( {
                        JsonMenu.SysTrayMenu.InvokeOption -ActionId $args[0].Name
                    })
                    $Container.MenuItems.AddRange($menuItem)
                    break
                }
                $JsonMenu.Constants.Menu.ExitType {
                    $menuItem = New-Object System.Windows.Forms.MenuItem
                    $menuItem.Text = $option.Value
                    $menuItem.Add_Click( {

                        [void][System.Windows.Forms.Application]::Exit($null)
                    })
                    $Container.MenuItems.AddRange($menuItem)
                    break
                }
                Default {}
            }
        }

        return $Container
    }
}
