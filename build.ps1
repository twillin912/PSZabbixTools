<#
#>
[CmdletBinding()]

Param
(
    [string] $Task = 'Build'
)

$RequiredModules = @('BuildHelpers','Psake','Pester','PlatyPS','PSScriptAnalyzer')

Write-Verbose -Message "Set package provider and verify required packages are installed."
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

foreach ( $Module in $RequiredModules )
{
    if ( !( Get-Module -ListAvailable -Name $Module ) )
    {
        Install-Module -Name $Module -Scope CurrentUser -Force | Out-Null
    }
}

Write-Verbose -Message "Set build environment using the BuildHelpers module."
    Set-BuildEnvironment

Write-Verbose -Message 'Invoking psake build script.'
    Invoke-PSake -buildFile .\build.psake.ps1 -taskList $Task -nologo

exit ( [int]( -not $psake.build_success ) )
