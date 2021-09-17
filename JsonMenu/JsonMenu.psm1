 # JsonMenu
# Copyright (c) 2021 Erwin Rijss
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


#Requires -Version 5.0

#Module folder
$jsonMenuModulePath = Split-Path $MyInvocation.MyCommand.Path

# Dot source public/private functions
$private = Get-ChildItem -Path (Join-Path $jsonMenuModulePath Private) -Include *.ps1 -File -Recurse -ErrorAction Stop
$public = Get-ChildItem -Path (Join-Path $jsonMenuModulePath Public) -Include *.ps1 -File -Recurse -ErrorAction Stop

($private + $public) | ForEach-Object {
    try {
        . $_.FullName
    }
    catch {
        Write-Warning $_.Exception.Message
    }
}

# manifest and version
$jsonMenuManifestPath = Join-Path $jsonMenuModulePath "JsonMenu.psd1"
$jsonMenuManifest = Test-ModuleManifest -Path $jsonMenuManifestPath -WarningAction SilentlyContinue

# JsonMenuContext
$script:JsonMenu = @{}

$JsonMenu.Info = @{
    Version = $jsonMenuManifest.Version.ToString()
    Created = 2021
    ShowLogo = 3
    ModulePath = $jsonMenuModulePath
    ConsoleIsMinimizable = $true
}

# holds the loaded configuration
$JsonMenu.Configuration = @{}

# constants used in code
$JsonMenu.Constants = @{
    Properties = @{
        Settings = "settings"
        Menus = "menus"
        Actions = "actions"
        Texts = "texts"
    }
    Menu = @{
        StartMenu = "main"
        Menutype = "menu"
        ExitType = "exit"
        ActionType = "action"
    }
}

# Holds the context of the loaded menu
$JsonMenu.Context = @{}

$JsonMenu.Context.Settings = @{
    MenuType = "Console"
    StartAction = ""
    StartMenu = "main"
    NoLogo = $false
    Option = @{
        Pattern = "{0}: {1}"
        PadLeft = 0
        PadRight = 0
    }
    Selection = @{
        PromptForChoice = "Select an option"
        PromptForAnyKey = "Click any key to continue"
    }
    Confirmation = @{
        Question = "Do you want to continue?"
        Continue = @{
            Label = "&Yes"
            Help = "Continue with the action"
        }
        Cancel = @{
            Label = "&No"
            Help = "Cancel this action and go back to the menu"
        }
    }
}
$JsonMenu.Context.Menus = @{}
$JsonMenu.Context.Actions = @{}
$JsonMenu.Context.Texts = @{}
$JsonMenu.Context.Repositories = @{}
$JsonMenu.Context.Modules = @{}
$JsonMenu.Context.Scripts  =@{}
$JsonMenu.Context.ActionContext = @{}
$JsonMenu.Context.ActionResults = @{}

Export-ModuleMember -function Invoke-JSonMenu
