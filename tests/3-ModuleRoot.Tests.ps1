[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe 'Module root' {
    $PublicFunctionFiles = (Get-ChildItem -Path "$env:BHPSModulePath\Public\*.ps1" -Recurse -ErrorAction SilentlyContinue).BaseName
    $ModuleFunctions = (Get-Command -Module $env:BHProjectName).Name

    Context 'Validation' {

    }

    Context 'Functions exported' {
        foreach ( $FunctionFile in $PublicFunctionFiles ) {
            It "Function $FunctionFile exported" {
                ( $FunctionFile -in $ModuleFunctions ) | Should Be $true
            }
        }
    }

    Context 'Pester coverage' {
        # foreach ( $FunctionFile in $PublicFunctionFiles ) {
        #     It "Function $FunctionFile has pester test" {
        #         "$env:BHProjectPath\Tests\$FunctionFile.Tests.ps1" | Should Exist
        #     }
        # }
    }
}