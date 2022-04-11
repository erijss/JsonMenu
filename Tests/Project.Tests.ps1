BeforeAll {
    $testsRoot = Resolve-Path $PSCommandPath

    do {
        $folderName = Split-Path $testsRoot -Leaf
        if ($folderName -eq "Tests") {
            #do nothing, tests folder found
        }
        else {
            $testsRoot = Split-Path -Parent $testsRoot
        }

    } until ($folderName -eq "Tests")

    $projectRoot = Resolve-Path "$testsRoot\.."
    $modulePath = Resolve-Path "$projectRoot\*\*.psm1"
    $manifestPath = Resolve-Path "$projectRoot\*\*.psd1"
    $rootOfModule = Split-Path ($modulePath)
    $moduleName = Split-Path $rootOfModule -Leaf
    $publicFunctionsRoot = Join-Path $rootOfModule "Public"
    $privateFunctionsRoot = Join-Path $rootOfModule "Private"

    Write-Host -Object "=================================================================" -ForegroundColor Cyan
    Write-Host -Object "Running $PSCommandpath" -ForegroundColor Cyan
    Write-Host -Object "Testing module: $moduleName" -ForegroundColor Cyan
    Write-Host -Object "With tests from: $testsRoot" -ForegroundColor Cyan
    Write-Host -Object "Module Path is: $modulePath" -ForegroundColor Cyan
    Write-Host -Object "Manifest path is: $manifestPath" -ForegroundColor Cyan
    Write-Host -Object "Project root is: $projectRoot" -ForegroundColor Cyan
    Write-Host -Object "Module root is: $rootOfModule" -ForegroundColor Cyan
    Write-Host -Object "Public functions: $publicFunctionsRoot" -ForegroundColor Cyan
    Write-Host -Object "Private functions: $privateFunctionsRoot" -ForegroundColor Cyan
    Write-Host "=================================================================" -ForegroundColor Cyan
}

Describe "Validate Modulename" {
    Context "Validate parameters" {
        It "should be true" {
            $moduleName | Should -Be "JsonMenu"
        }
    }
}

Describe "Basic Module Testing" {
    # Original idea from: https://kevinmarquette.github.io/2017-01-21-powershell-module-continious-delivery-pipeline/
    $scripts = Get-ChildItem $rootOfModule -Include *.ps1, *.psm1, *.psd1 -Recurse
    $testCase = $scripts | Foreach-Object {
        @{
            FilePath = $_.fullname
            FileName = $_.Name
        }
    }
    It "Script <FileName> should be valid powershell" -TestCases $testCase {
        param(
            $FilePath,
            $FileName
        )

        $FilePath | Should -Exist

        $contents = Get-Content -Path $FilePath -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should -Be 0
    }

    It "Module $moduleName can import cleanly" {
        { Import-Module -Name $modulePath -Force } | Should -Not -Throw
    }
}


Describe "Manifest Testing" {
    It 'Valid Module Manifest' {
        {
            $Script:Manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should -Not -Throw
    }
    It 'Valid Manifest Name' {
        $Script:Manifest.Name | Should -Be $moduleName
    }
    It 'Generic Version Check' {
        $Script:Manifest.Version -as [Version] | Should -Not -BeNullOrEmpty
    }
    It 'Valid Manifest Description' {
        $Script:Manifest.Description | Should -Not -BeNullOrEmpty
    }
    It 'Valid Manifest Root Module' {
        $Script:Manifest.RootModule | Should -Be "$moduleName.psm1"
    }
    It 'Valid Manifest GUID' {
        $Script:Manifest.Guid | Should -Be 'e5be88cd-c473-438c-83db-d856843363b3'
    }
    It 'No Format File' {
        $Script:Manifest.ExportedFormatFiles | Should -BeNullOrEmpty
    }

    It 'Required Modules' {
        $Script:Manifest.RequiredModules | Should -BeNullOrEmpty
    }
}

Describe "Exported Functions Testing" {
    $ExportedFunctions = (Get-ChildItem -Path $publicFunctionsRoot -Filter *.ps1 | Select-Object -ExpandProperty Name ) -replace '\.ps1$'
    $testCase = $ExportedFunctions | Foreach-Object { @{FunctionName = $_ } }
    It "Function <FunctionName> should be in manifest" -TestCases $testCase {
        param($FunctionName)
        $ManifestFunctions = $Script:Manifest.ExportedFunctions.Keys
        $FunctionName -in $ManifestFunctions | Should -Be $true
    }

    It 'Proper Number of Functions Exported compared to Manifest' {
        $ExportedCount = Get-Command -Module $moduleName -CommandType Function | Measure-Object | Select-Object -ExpandProperty Count
        $ManifestCount = $Script:Manifest.ExportedFunctions.Count

        $ExportedCount | Should -Be $ManifestCount
    }

    It 'Proper Number of Functions Exported compared to Files' {
        $ExportedCount = Get-Command -Module $moduleName -CommandType Function | Measure-Object | Select-Object -ExpandProperty Count
        $FileCount = Get-ChildItem -Path $publicFunctionsRoot -Filter *.ps1 | Measure-Object | Select-Object -ExpandProperty Count

        $ExportedCount | Should -Be $FileCount
    }

    $InternalFunctions = (Get-ChildItem -Path $privateFunctionsRoot -Filter *.ps1 | Select-Object -ExpandProperty Name ) -replace '\.ps1$'
    $testCase = $InternalFunctions | Foreach-Object { @{FunctionName = $_ } }
    It "Internal function <FunctionName> is not directly accessible outside the module" -TestCases $testCase {
        param($FunctionName)
        { . $FunctionName } | Should -Throw
    }
}

Describe "Exported Aliases Testing" {
    Context 'Exported Aliases' {
        It 'Proper Number of Aliases Exported compared to Manifest' {
            $ExportedCount = Get-Command -Module $moduleName -CommandType Alias | Measure-Object | Select-Object -ExpandProperty Count
            $ManifestCount = $Manifest.ExportedAliases.Count

            $ExportedCount | Should -Be $ManifestCount
        }

        It 'Proper Number of Aliases Exported compared to Files' {
            $AliasCount = Get-ChildItem -Path "$rootOfModule" -Filter *.ps1 | Select-String "New-Alias" | Measure-Object | Select-Object -ExpandProperty Count
            $ManifestCount = $Manifest.ExportedAliases.Count

            $AliasCount  | Should -Be $ManifestCount
        }
    }
}



# Describe "ScriptAnalyzer" {
#     $PSScriptAnalyzerSettings = @{
#         Severity    = @('Error', 'Warning')
#         ExcludeRule = @('PSUseSingularNouns')
#     }
#     # Test all functions with PSScriptAnalyzer
#     $ScriptAnalyzerErrors = @()
#     $ScriptAnalyzerErrors += Invoke-ScriptAnalyzer -Path "$ModulePath\functions" @PSScriptAnalyzerSettings
#     $ScriptAnalyzerErrors += Invoke-ScriptAnalyzer -Path "$ModulePath\internal\functions" @PSScriptAnalyzerSettings
#     # Get a list of all internal and Exported functions
#     $InternalFunctions= Get-ChildItem -Path "$ModulePath\internal\functions" -Filter *.ps1 | Select-Object -ExpandProperty Name
#     $ExportedFunctions = Get-ChildItem -Path "$ModulePath\functions" -Filter *.ps1 | Select-Object -ExpandProperty Name
#     $AllFunctions = ($InternalFunctions + $ExportedFunctions) | Sort-Object
#     $FunctionsWithErrors = $ScriptAnalyzerErrors.ScriptName | Sort-Object -Unique
#     if ($ScriptAnalyzerErrors) {
#         $testCase = $ScriptAnalyzerErrors | Foreach-Object {
#             @{
#                 RuleName   = $_.RuleName
#                 ScriptName = $_.ScriptName
#                 Message    = $_.Message
#                 Severity   = $_.Severity
#                 Line       = $_.Line
#             }
#         }
#         # Compare those with not successful
#         $FunctionsWithoutErrors = Compare-Object -ReferenceObject $AllFunctions -DifferenceObject $FunctionsWithErrors  | Select-Object -ExpandProperty InputObject
#         Context 'ScriptAnalyzer Testing' {
#             It "Function <ScriptName> should not use <Message> on line <Line>" -TestCases $testCase {
#                 param(
#                     $RuleName,
#                     $ScriptName,
#                     $Message,
#                     $Severity,
#                     $Line
#                 )
#                 $ScriptName | Should BeNullOrEmpty
#             }
#         }
#     } else {
#         # Everything was perfect, let's show that as well
#         $FunctionsWithoutErrors = $AllFunctions
#     }

#     # Show good functions in the test, the more green the better
#     Context 'Successful ScriptAnalyzer Testing' {
#         $testCase = $FunctionsWithoutErrors | Foreach-Object {
#             @{
#                 ScriptName = $_
#             }
#         }
#         It "Function <ScriptName> has no ScriptAnalyzerErrors" -TestCases $testCase {
#             param(
#                 $ScriptName
#             )
#             $ScriptName | Should Not BeNullOrEmpty
#         }
#     }
# }
