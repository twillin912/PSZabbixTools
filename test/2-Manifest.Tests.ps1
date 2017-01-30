[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $true
. $PSScriptRoot\Shared.ps1

$AppVeyorPath = Join-Path -Path $ProjectRoot -Child "appveyor.yml"
$ChangeLogPath = Join-Path -Path $ProjectRoot -Child "CHANGELOG.md"
$ReleaseNotesPath = Join-Path -Path $ProjectRoot -Child "ReleaseNotes.md"

Describe 'Module manifest' {
    Context 'Validation' {

        $script:Manifest = $null

        It "has a valid manifest" {
            {
                $script:Manifest = Test-ModuleManifest -Path "$($SrcRootDir)\$($ModuleName).psd1" -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }

        It "has a valid name in the manifest" {
            $script:Manifest.Name | Should Be $ModuleName
        }

        It 'has a valid root module' {
            $script:Manifest.RootModule | Should Be "$ModuleName.psm1"
        }

        It "has a valid version in the manifest" {
            $script:Manifest.Version -as [Version] | Should Not BeNullOrEmpty
        }

        It 'has a valid description' {
            $script:Manifest.Description | Should Not BeNullOrEmpty
        }

        It 'has a valid author' {
            $script:Manifest.Author | Should Not BeNullOrEmpty
        }

        It 'has a valid guid' {
            {
                [guid]::Parse($script:Manifest.Guid)
            } | Should Not throw
        }

        It 'has a valid copyright' {
            $script:Manifest.CopyRight | Should Not BeNullOrEmpty
        }

        # Only for DSC modules
        # It 'exports DSC resources' {
        #     $dscResources = ($Manifest.psobject.Properties | Where Name -eq 'ExportedDscResources').Value
        #     @($dscResources).Count | Should Not Be 0
        # }
    }

    Context 'Versioning' {

        $script:AppVeyorVersion = $null
        It "has a valid version in the appveyor config" {
            foreach ($line in (Get-Content $AppVeyorPath)) {
                if ($line -match "^version: (?<Version>(\d+(\.\d+){1,3})).*") {
                    $script:AppVeyorVersion = $matches.Version
                    break
                }
            }
            $script:AppVeyorVersion                | Should Not BeNullOrEmpty
            $script:AppVeyorVersion -as [Version]  | Should Not BeNullOrEmpty
            Write-Verbose $script:AppVeyorVersion
        }

        $script:ChangeLogVersion = $null
        It "has a valid version in the change log" {
            foreach ($line in (Get-Content $ChangeLogPath)) {
                if ($line -match "^## (?<Version>(\d+\.){1,3}\d+)") {
                    $script:ChangeLogVersion = $matches.Version
                    break
                }
            }
            $script:ChangeLogVersion                | Should Not BeNullOrEmpty
            $script:ChangeLogVersion -as [Version]  | Should Not BeNullOrEmpty
        }

        $script:ReleaseNotesVersion = $null
        It "has a valid version in the release notes" {
            foreach ($line in (Get-Content $ReleaseNotesPath)) {
                if ($line -match "(?<Version>(\d+\.){1,3}\d+)$") {
                    $script:ReleaseNotesVersion = $matches.Version
                    break
                }
            }
            $script:ReleaseNotesVersion                | Should Not BeNullOrEmpty
            $script:ReleaseNotesVersion -as [Version]  | Should Not BeNullOrEmpty
        }

        It "appveyor config and manifest versions are the same" {
            $script:AppVeyorVersion -as [Version] | Should be ( $script:Manifest.Version -as [Version] )
        }

        It "change log and manifest versions are the same" {
            $script:ChangeLogVersion -as [Version] | Should be ( $script:Manifest.Version -as [Version] )
        }

        It "release notes and manifest versions are the same" {
            $script:ReleaseNotesVersion -as [Version] | Should be ( $script:Manifest.Version -as [Version] )
        }

    }

}


