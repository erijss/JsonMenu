# $functions = Get-ChildItem -Path "D:\Code\JsonMenuProject_202108\JsonMenu\Private" -Include *.ps1 -File -Recurse -ErrorAction Stop

# # Private must be sourced first - usage in public functions during load
# ($functions) | ForEach-Object {
#     try {
#         . $_.FullName
#     }
#     catch {
#         Write-Warning $_.Exception.Message
#     }
# }

# $jsonObject = Get-Content -Path "D:\Code\JsonMenuProject_202108\Examples\menu.json"  -Force -Raw | ConvertFrom-Json

# $menusraw = $jsonObject.Menus
# $menushash = $jsonObject.Menus | JsonMenu.Functions.ConvertToHashtable
# $menushash2 = $jsonObject.Menus | JsonMenu.Functions.ConvertPSObjectToHashtable

# $rawid = $menusraw.MainMenu.Id
# $hashid = $menushash.MainMenu.Id
# $hashid2 = $menushash2.MainMenu.Id


# Write-Output "end"
