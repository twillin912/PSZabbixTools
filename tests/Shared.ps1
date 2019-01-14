# Dot source this script in any Pester test script that requires the module to be imported.

if (!$SuppressImportModule) {
    Get-Module -Name $env:BHProjectName | Remove-Module -Force
    Import-Module "$env:BHPSModuleManifest" -Scope Global
}
