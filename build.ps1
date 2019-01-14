[CmdletBinding()]
Param (
    [string] $Task = '.'
)

$RequiredModules = @('BuildHelpers', 'InvokeBuild', 'Pester', 'PlatyPS', 'PSDeploy', 'PSScriptAnalyzer')

Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
foreach ( $Module in $RequiredModules ) {
    if ( ! ( Get-Module -Name $Module -ListAvailable ) ) { Install-Module -Name $Module -Scope CurrentUser -Force | Out-Null }
}

Set-BuildEnvironment -Force
Invoke-Build -File $env:BHProjectPath\build\build.script.ps1 -Task $Task
