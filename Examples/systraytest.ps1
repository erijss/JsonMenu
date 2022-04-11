# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()

# Declare assemblies
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')    | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework')   | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')    | out-null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | out-null

# Add an icon to the systrauy button
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\Magnify.exe")

# Create object for the systray
$Systray_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
# Text displayed when you pass the mouse over the systray icon
$Systray_Tool_Icon.Text = "TEXTTITLETEXTTITLETEXT"
# Systray icon
$Systray_Tool_Icon.Icon = $icon
$Systray_Tool_Icon.Visible = $true

# First menu displayed in the Context menu
$Menu1 = New-Object System.Windows.Forms.MenuItem
$Menu1.Text = "TEXTMENU1TEXT"
# Second menu displayed in the Context menu
$Menu2 = New-Object System.Windows.Forms.MenuItem
$Menu2.Text = "TEXTMENU2TEXT"
# Third menu displayed in the Context menu
$Menu3 = New-Object System.Windows.Forms.MenuItem
$Menu3.Text = "TEXTMENU3TEXT"
# Fourth menu displayed in the Context menu
$Menu4 = New-Object System.Windows.Forms.MenuItem
$Menu4.Text = "TEXTMENU4TEXT"

# Fifth menu displayed in the Context menu - This will close the systray tool
$Menu_Exit = New-Object System.Windows.Forms.MenuItem
$Menu_Exit.Text = "Exit"

# Create the context menu for all menus above
$contextmenu = New-Object System.Windows.Forms.ContextMenu
$Systray_Tool_Icon.ContextMenu = $contextmenu
$Systray_Tool_Icon.contextMenu.MenuItems.AddRange($Menu1)
$Systray_Tool_Icon.contextMenu.MenuItems.AddRange($Menu2)
$Systray_Tool_Icon.contextMenu.MenuItems.AddRange($Menu3)
$Systray_Tool_Icon.contextMenu.MenuItems.AddRange($Menu4)
$Systray_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)

# Create submenu for the menu 1
$Menu1_SubMenu1 = $Menu1.MenuItems.Add("TEST1TEXT")
# Create submenu for the menu 2
$Menu2_SubMenu1 = $Menu2.MenuItems.Add("TEST2TEXT")
# Create submenu for the menu 3
$Menu3_SubMenu1 = $Menu3.MenuItems.Add("TEST3TEXT")
# Create submenu for the menu 4
$Menu4_SubMenu1 = $Menu4.MenuItems.Add("TEST4TEXT")


# Action after clicking on the Menu 1 - Submenu 1
$Menu1_SubMenu1.Add_Click({
        start-process powershell
    })

# Action after clicking on the Menu 2 - Submenu 1
$Menu2_SubMenu1.Add_Click({
        start-process "C:\Windows\system32\dsa.msc"
    })

# Action after clicking on the Menu 3 - Submenu 1
$Menu3_SubMenu1.Add_Click({
        start-process cmd
    })

# When Exit is clicked, close everything and kill the PowerShell process
$Menu_Exit.add_Click({
        start-process powershell
        $Systray_Tool_Icon.Visible = $false
        $window.Close()
        # $window_Config.Close()
        Stop-Process $pid
    })

# Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)



# Create an application context for it to all run within.
# This helps with responsiveness, especially when clicking Exit.
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)
