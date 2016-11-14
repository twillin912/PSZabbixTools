[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $true
. $PSScriptRoot\Shared.ps1

Describe 'File Formatting' {

    $Textfiles = Get-ChildItem -Path $ProjectRoot -Include '*.ps1', '*.psm1', '*.psd1' -Recurse

    It "Doesn't use Unicode encoding" {
        $FileCount = 0
        $Textfiles | %{
            $FileName = $_.FullName
            $bytes = [System.IO.File]::ReadAllBytes($FileName)
            $zeroBytes = @($bytes -eq 0)
            if ( $zeroBytes.Length -ne 0 ) {
                $FileCount += 1
                Write-Warning "File $($_.FullName) contains 0x00 bytes. It's probably uses Unicode and need to be converted to UTF-8."
            }
        }
        $FileCount | Should Be 0
    }

    It 'Uses spaces for indentation, not tabs' {
        $TabCount = 0
        $Textfiles | % {
            $FileName = $_.FullName
            (Get-Content $FileName -Raw) | Select-String "`t" | % {
                Write-Warning "There are tab in $FileName."
                $TabCount++
            }
        }
        $TabCount | Should Be 0
    }
}