# Dot source this script in any Pester test script that requires the module to be imported.
Set-StrictMode -Version latest

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the PoshZabbixTools\ namespace
    Import-Module $env:BHPSModuleManifest -Scope Global
}

