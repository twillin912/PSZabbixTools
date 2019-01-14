[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot/../Shared.ps1

Describe 'Module root' {
    $PrivateFunctions = Get-ChildItem -Path "$env:BHPSModulePath/Private" -Include '*.ps1' -Recurse -ErrorAction SilentlyContinue
    $PublicFunctions = Get-ChildItem -Path "$env:BHPSModulePath/Public" -Include '*.ps1' -Recurse -ErrorAction SilentlyContinue
    $ExportedFunctions = (Get-Command -Module $env:BHProjectName).Name

    $AllFunctions = New-Object System.Collections.Generic.List[System.Object]
    $AllFunctions.Add($PrivateFunctions)
    $AllFunctions.Add($PublicFunctions)

    Context 'Private Functions not exported' {
        foreach ( $Function in $PrivateFunctions ) {
            It "Function $($Function.BaseName) not exported" {
                ( $($Function.BaseName) -in $ExportedFunctions ) | Should Be $false
            }
        }
    }

    Context 'Public Functions exported' {
        foreach ( $Function in $PublicFunctions ) {
            It "Function $($Function.BaseName) exported" {
                ( $($Function.BaseName) -in $ExportedFunctions ) | Should Be $true
            }
        }
    }
}
