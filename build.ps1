#Requires -Modules buildhelpers,psake
[CmdletBinding()]
Param (
    [string] $Task = 'Build'
)

Set-BuildEnvironment -Path "$PSScriptRoot" -Verbose:$VerbosePreference

Write-Verbose -Message "Calling Invoke-psake with build file '$env:BHProjectPath\build\build.psake.ps1'"
Invoke-psake -buildFile "$env:BHProjectPath\build\build.psake.ps1" -taskList $Task
