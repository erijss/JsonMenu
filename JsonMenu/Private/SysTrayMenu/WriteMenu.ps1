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
        [System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | out-null

        # Add-Type -Name Window -Namespace Console -MemberDefinition '
        # [DllImport("Kernel32.dll")]
        # public static extern IntPtr GetConsoleWindow();

        # [DllImport("user32.dll")]
        # public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'


        # Force garbage collection just to start slightly lower RAM usage.
        [System.GC]::Collect()

        $appContext = New-Object System.Windows.Forms.ApplicationContext

        $icon = Join-Path -Path $JsonMenu.Constants.Settings.ModuleRoot -ChildPath "JsonMenuLogo.ico"
        $sysTrayMenu = New-Object System.Windows.Forms.NotifyIcon
        $sysTrayMenu.Text = $JsonMenu.Context.Menus[$MenuId].Id
        $sysTrayMenu.Icon = $icon
        $sysTrayMenu.Visible = $true

        $menuOptions = $JsonMenu.Context.Menus[$MenuId].Options
        $contextMenu = New-Object System.Windows.Forms.ContextMenu
        $contextMenu = JsonMenu.SysTrayMenu.WriteOptions -Container $contextMenu -Options $menuOptions

        $sysTrayMenu.ContextMenu = $contextMenu

        # try {
        #     $JsonMenu.Constants.Settings.ConsoleIsMinimizable = $true
        #     $JsonMenu.Constants.Settings.ConsoleIsMinimizable = JsonMenu.SysTrayMenu.HideConsole
        # }
        # catch {
        #     $JsonMenu.Constants.Settings.ConsoleIsMinimizable = $false
        #     # $sysTrayMenu.Visible = $false
        # }

        [void][System.Windows.Forms.Application]::Run($appContext).WaitForExit()
    }

}
