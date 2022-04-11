function JsonMenu.SysTrayMenu.WriteMenu {
  <#
    .SYNOPSIS
    .DESCRIPTION
    #>
  param (
    [Parameter()]
    [String]
    $MenuId
  )

  process {
    # Declare assemblies
    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')    | out-null
    [System.Reflection.Assembly]::LoadWithPartialName('presentationframework')   | out-null
    [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')    | out-null

    Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'


    # Force garbage collection just to start slightly lower RAM usage.
    [System.GC]::Collect()

    $appContext = New-Object System.Windows.Forms.ApplicationContext

    $icon = Join-Path -Path $JsonMenu.Info.ModulePath -ChildPath "JsonMenuLogo.ico"
    $sysTrayMenu = New-Object System.Windows.Forms.NotifyIcon
    $sysTrayMenu.Text = $JsonMenu.Context.Menus[$MenuId].Id
    $sysTrayMenu.Icon = $icon
    $sysTrayMenu.Visible = $true

    $menuOptions = $JsonMenu.Context.Menus[$MenuId].Options
    $contextMenuStrip = New-Object System.Windows.Forms.ContextMenuStrip

    # Thie code should be rewritten as it seems that the original does not work anymore
    # Find out how to net ToolstripMenuItem
    # https://www.systanddeploy.com/2020/09/build-powershell-systray-tool-with.html

    # build form in Visual Studio and convert to powershell
    # https://domruggeri.com/2019/07/06/creating-extensive-powershell-gui-applications-part-1/

    # origineel datniet meer werkt
    # https://automateanddeploy.com/index.php/2020/06/24/powershell-system-tray-tool/

    # Solve Write-Host stuff. Seems that it not works because you're in function
    # Maybe execute actions in new window?

    foreach ($option in $menuOptions) {
      switch ( $option.type ) {
        $JsonMenu.Constants.Menu.MenuType {
          $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
          $menuItem.Text = $option.Value
          $menuOptions = $JsonMenu.Context.Menus[$option.Action].Options
          $menuItem = JsonMenu.SysTrayMenu.WriteOptions -Container $menuItem -Options $menuOptions
          $contextMenuStrip.Items.Add($menuItem)
          break
        }
        $JsonMenu.Constants.Menu.ActionType {
          $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
          $menuItem.Text = $option.Value
          $menuItem.Name = $option.action
          $menuItem.Add_Click( {
              JsonMenu.SysTrayMenu.InvokeOption -ActionId $args[0].Name
            })
          $contextMenuStrip.Items.Add($menuItem)
          break
        }
        $JsonMenu.Constants.Menu.ExitType {
          $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
          $menuItem.Text = $option.Value
          $menuItem.Add_Click( {

              [void][System.Windows.Forms.Application]::Exit($null)
            })
          $contextMenuStrip.Items.Add($menuItem)
          break
        }
        Default {}
      }
    }



    # $contextMenuStrip = JsonMenu.SysTrayMenu.WriteOptions -Container $contextMenuStrip -Options $menuOptions

    # $Menu_1 = $contextMenuStrip.Items.Add("Menu 1");
    # $Menu_2 = $contextMenuStrip.Items.Add("Menu 2");
    # $Menu_Restart = $contextMenuStrip.Items.Add("Restart the tool");
    # $Menu_Exit = $contextMenuStrip.Items.Add("Exit");

    # #Sub menus for Menu 1
    # $Menu1_SubMenu1 = New-Object System.Windows.Forms.ToolStripMenuItem
    # $Menu1_SubMenu1.Text = "Menu 1 - Sub menu 1"
    # $Menu_1.DropDownItems.Add($Menu1_SubMenu1)

    # $Menu1_SubMenu2 = New-Object System.Windows.Forms.ToolStripMenuItem
    # $Menu1_SubMenu2.Text = "Menu 1 - Sub menu 2"
    # $Menu_1.DropDownItems.Add($Menu1_SubMenu2)

    # #Sub menus for Menu 2
    # $Menu2_SubMenu1 = New-Object System.Windows.Forms.ToolStripMenuItem
    # $Menu2_SubMenu1.Text = "Menu 2 - Sub menu 1"
    # $Menu_2.DropDownItems.Add($Menu2_SubMenu1)

    # $Menu2_SubMenu2 = New-Object System.Windows.Forms.ToolStripMenuItem
    # $Menu2_SubMenu2.Text = "Menu 2 - Sub menu 2"
    # $Menu_2.DropDownItems.Add($Menu2_SubMenu2)

    $sysTrayMenu.ContextMenuStrip = $contextMenuStrip

    try {
      $JsonMenu.Info.ConsoleIsMinimizable = $true
      $JsonMenu.Info.ConsoleIsMinimizable = JsonMenu.SysTrayMenu.HideConsole
    }
    catch {
      $JsonMenu.Info.ConsoleIsMinimizable = $false
      # $sysTrayMenu.Visible = $false
    }

    [void][System.Windows.Forms.Application]::Run($appContext).WaitForExit()
  }

}
