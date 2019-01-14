[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $true
. $PSScriptRoot/../Shared.ps1

$ChangeLogPath = Join-Path -Path $env:BHProjectPath -Child "CHANGELOG.md"
$ReleaseNotesPath = Join-Path -Path $env:BHProjectPath -Child "ReleaseNotes.md"

Describe 'Module manifest' {
    Context 'Validation' {

        $script:Manifest = $null

        It "has a valid manifest" {
            {
                $script:Manifest = Test-ModuleManifest -Path "$env:BHPSModuleManifest" -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }

        It "has a valid name in the manifest" {
            $script:Manifest.Name | Should Be $env:BHProjectName
        }

        It 'has a valid root module' {
            $script:Manifest.RootModule | Should Be "$env:BHProjectName.psm1"
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
        $script:ManifestVersion = New-Object -TypeName Version -ArgumentList $script:Manifest.Version.Major, $script:Manifest.Version.Minor

        $script:ChangeLogVersion = $null
        It "has a valid version in the change log" {
            foreach ($line in (Get-Content $ChangeLogPath)) {
                if ($line -match "^## v(?<Version>(\d+\.){1,3}\d+)") {
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
                if ($line -match "v(?<Version>(\d+\.){1,3}\d+)$") {
                    $script:ReleaseNotesVersion = $matches.Version
                    break
                }
            }
            $script:ReleaseNotesVersion                | Should Not BeNullOrEmpty
            $script:ReleaseNotesVersion -as [Version]  | Should Not BeNullOrEmpty
        }

        It "change log and manifest versions are the same" {
            $script:ChangeLogVersion -as [Version] | Should be ( $script:ManifestVersion -as [Version] )
        }

        It "release notes and manifest versions are the same" {
            $script:ReleaseNotesVersion -as [Version] | Should be ( $script:ManifestVersion -as [Version] )
        }

    }

}
