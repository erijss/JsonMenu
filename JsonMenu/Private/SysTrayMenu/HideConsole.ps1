function JsonMenu.SysTrayMenu.HideConsole {
    $PSConsole = [Console.Window]::GetConsoleWindow()
    $result = [Console.Window]::ShowWindow($PSConsole, 7)
    return $result
 }