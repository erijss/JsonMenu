[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Task = 'Default'
)
process {

    # Grab nuget bits, install modules, set build variables, start build.
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

    Install-Module Psake, PSDeploy, BuildHelpers -force
    Install-Module Pester -Force -SkipPublisherCheck
    Import-Module Psake, BuildHelpers

    Set-BuildEnvironment

    Invoke-psake -buildFile .\psake.ps1 -taskList $Task -nologo
    exit ( [int]( -not $psake.build_success ) )
}
