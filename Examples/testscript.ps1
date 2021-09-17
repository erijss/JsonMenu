$functions = Get-ChildItem -Path "D:\Code\JsonMenu\JsonMenu\Private" -Include *.ps1 -File -Recurse -ErrorAction Stop

# Private must be sourced first - usage in public functions during load
($functions) | ForEach-Object {
    try {
        . $_.FullName
    }
    catch {
        Write-Warning $_.Exception.Message
    }
}

$jsonObject = Get-Content -Path "D:\Code\JsonMenu\Examples\menu.json"  -Force -Raw | ConvertFrom-Json

$a = 1..5
$b = 6..10
$c = 11..15
$d = 16..20
$array = $a,$b,$c,$d

$collectionWithItems = New-Object System.Collections.ArrayList
for($i = 0; $i -lt 10; $i++)
{
    $temp = New-Object System.Object
    $temp | Add-Member -MemberType NoteProperty -Name "Field1" -Value "Value1"
    $temp | Add-Member -MemberType NoteProperty -Name "Field2" -Value "Value2"
    $temp | Add-Member -MemberType NoteProperty -Name "Field3" -Value "Value3"
    $collectionWithItems.Add($temp) | Out-Null
}

$processes = Get-Process

$o_menus = $jsonObject.Menus
$o_settings = $jsonObject.Settings

# $processes_hash = $processes | JsonMenu.Functions.ConvertToHashtable
# $collectionWithItems_hash = $collectionWithItems | JsonMenu.Functions.ConvertToHashtable
# $array_hash = $array | JsonMenu.Functions.ConvertToHashtable
$o_menus_hash = $o_menus | JsonMenu.Functions.ConvertToHashtable
$o_settings_hash = $o_settings | JsonMenu.Functions.ConvertToHashtable

Write-Output $o_settings | Format-Table
Write-Output $o_settings_hash | Format-Table
Write-Output $o_menus | Format-Table
Write-Output $o_menus_hash | Format-Table

# $menusraw = $jsonObject.Menus
# $menushash = $jsonObject.Menus | JsonMenu.Functions.ConvertToHashtable
# $menushash2 = $jsonObject.Menus | JsonMenu.Functions.ConvertPSObjectToHashtable

# $rawid = $menusraw.MainMenu.Id
# $hashid = $menushash.MainMenu.Id
# $hashid2 = $menushash2.MainMenu.Id
Write-Host $o_settings_hash.nologo
Write-Host $o_settings_hash.confirmation.continue.label

foreach ($menu in $o_menus_hash) {
    Write-Host $menu.id
}


Write-Output "end"
