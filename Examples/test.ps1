# $p = @{
#     Name = "Jann"
# }
# . D:\Code\JsonMenu\JsonMenu\Demo\DemoScript.ps1 -Name "Erwin"
# . D:\Code\JsonMenu\JsonMenu\Demo\DemoScript.ps1 @p


function LoadModule {
    . D:\Code\JsonMenu\JsonMenu\Demo\DemoScriptWithFunction.ps1 -Name "ERwin"
    Write-HelloMoon -Name "ERwin"

}

function CallMethod {
    # Write-HelloMoon
}

function StartAction {
    LoadModule
    CallMethod
}

StartAction
