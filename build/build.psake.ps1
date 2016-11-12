#Requires -Modules psake
###############################################################################
# Dot source the user's customized properties and extension tasks.
###############################################################################
. "$env:BHProjectPath\build\build.settings.ps1"

###############################################################################
# Private properties.
###############################################################################
Properties {

}

Task default -depends Build

Task Init -requiredVariables BuildRootDir {
    Get-Item env:BH* -Verbose:$VerbosePreference
    if ( $env:BHBuildSystem -eq 'AppVeyor' ) {
        $ModuleVersion = (Test-ModuleManifest -Path $env:BHPSModuleManifest).Version -as [string]
        $BuildVersion = "$ModuleVersion.$env:APPVEYOR_BUILD_NUMBER"
        Update-AppveyorBuild -Version $BuildVersion
    }
}

Task Analyze -depends Init `
             -requiredVariables ScriptAnalysisEnabled, ScriptAnalysisFailBuildOnSeverityLevel, ScriptAnalyzerSettingsPath {
    if (!$ScriptAnalysisEnabled) {
        "Script analysis is not enabled. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if (!(Get-Module PSScriptAnalyzer -ListAvailable)) {
        "PSScriptAnalyzer module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    "ScriptAnalysisFailBuildOnSeverityLevel set to: $ScriptAnalysisFailBuildOnSeverityLevel"

    $analysisResult = Invoke-ScriptAnalyzer -Path $env:BHPSModulePath -Settings $ScriptAnalyzerSettingsPath -Recurse -Verbose:$VerbosePreference
    $analysisResult | Format-Table
    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {
        'None' {
            return
        }
        'Error' {
            Assert -conditionToCheck (
                ($analysisResult | Where-Object Severity -eq 'Error').Count -eq 0
                ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'
        }
        'Warning' {
            Assert -conditionToCheck (
                ($analysisResult | Where-Object {
                    $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'
        }
        default {
            Assert -conditionToCheck (
                $analysisResult.Count -eq 0
                ) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'
        }
    }
}

Task BuildHelp -depends BeforeBuildHelp, GenerateMarkdown, GenerateHelpFiles, AfterBuildHelp {
}

Task GenerateMarkdown -requiredVariables DefaultLocale, DocsRootDir, DocsCommandDir {
    if (!(Get-Module platyPS -ListAvailable)) {
        "platyPS module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    $moduleInfo = Import-Module $env:BHPSModulePath\$env:BHProjectName.psd1 -Global -Force -PassThru

    try {
        if ($moduleInfo.ExportedCommands.Count -eq 0) {
            "No commands have been exported. Skipping $($psake.context.currentTaskName) task."
            return
        }

        if (!(Test-Path -LiteralPath $DocsRootDir)) {
            New-Item $DocsRootDir -ItemType Directory > $null
        }

        if (Get-ChildItem -LiteralPath $DocsRootDir -Filter *.md -Recurse) {
            Get-ChildItem -LiteralPath $DocsRootDir -Directory | ForEach-Object {
                Update-MarkdownHelp -Path $_.FullName -Verbose:$VerbosePreference > $null
            }
        }

        # ErrorAction set to SilentlyContinue so this command will not overwrite an existing MD file.
        New-MarkdownHelp -Module $env:BHProjectName -Locale $DefaultLocale -OutputFolder $DocsCommandDir `
                         -WithModulePage -ErrorAction SilentlyContinue -Verbose:$VerbosePreference > $null
    }
    finally {
        Remove-Module $env:BHProjectName
    }
}

Task GenerateHelpFiles -requiredVariables DocsRootDir, DocsCommandDir {
    if (!(Get-Module platyPS -ListAvailable)) {
        "platyPS module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if (!(Get-ChildItem -LiteralPath $DocsRootDir -Filter *.md -Recurse -ErrorAction SilentlyContinue)) {
        "No markdown help files to process. Skipping $($psake.context.currentTaskName) task."
        return
    }

    # Generate the module's primary MAML help file.
    New-ExternalHelp -Path $DocsCommandDir -OutputPath $env:BHPSModulePath\$DefaultLocale -Force `
                        -ErrorAction SilentlyContinue -Verbose:$VerbosePreference > $null
}

Task BuildUpdatableHelp -depends BuildHelp, BeforeBuildUpdatableHelp, CoreBuildUpdatableHelp, AfterBuildUpdatableHelp {
}

Task CoreBuildUpdatableHelp -requiredVariables DocsRootDir, UpdatableHelpOutDir {
    if (!(Get-Module platyPS -ListAvailable)) {
        "platyPS module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    # Create updatable help output directory.
    if (!(Test-Path -LiteralPath $UpdatableHelpDir)) {
        New-Item $UpdatableHelpDir -ItemType Directory -Verbose:$VerbosePreference > $null
    }
    else {
        Write-Verbose "$($psake.context.currentTaskName) - directory already exists '$UpdatableHelpDir'."
        Get-ChildItem $UpdatableHelpDir | Remove-Item -Recurse -Force -Verbose:$VerbosePreference
    }

    # Generate updatable help files.  Note: this will currently update the version number in the module's MD
    # file in the metadata.
    New-ExternalHelpCab -CabFilesFolder $env:BHPSModulePath\$DefaultLocale -LandingPagePath $DocsCommandDir\$env:BHProjectName.md `
                        -OutputFolder $UpdatableHelpDir -Verbose:$VerbosePreference > $null
}

Task Build -depends Init, BeforeBuild, Analyze, BeforeBuild, CoreBuild, AfterBuild {
}

Task CoreBuild -requiredVariables ReleaseDir {
    # if (!(Test-Path -LiteralPath $ReleaseDir)) {
    #     New-Item $ReleaseDir -ItemType Directory > $null
    # }
}

Task Test -depends Build -requiredVariables TestRootDir, CodeCoverageEnabled, CodeCoverageFiles {
    if (!(Get-Module Pester -ListAvailable)) {
        "Pester module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    Import-Module Pester

    try {
        Microsoft.PowerShell.Management\Push-Location -LiteralPath $TestRootDir

        if ($TestOutputFile) {
            $testing = @{
                OutputFile   = $TestOutputFile
                OutputFormat = $TestOutputFormat
                PassThru     = $true
                Verbose      = $VerbosePreference
            }
        }
        else {
            $testing = @{
                PassThru     = $true
                Verbose      = $VerbosePreference
            }
        }

        # To control the Pester code coverage, a boolean $CodeCoverageEnabled is used.
        if ($CodeCoverageEnabled) {
            $testing.CodeCoverage = $CodeCoverageFiles
        }

        $testResult = Invoke-Pester @testing

        if ( $env:BHBuildSystem -eq 'AppVeyor' ) {
            (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $TestOutputFile))
        }

        Assert -conditionToCheck (
            $testResult.FailedCount -eq 0
        ) -failureMessage "One or more Pester tests failed, build cannot continue."

        if ($CodeCoverageEnabled) {
            $testCoverage = [int]($testResult.CodeCoverage.NumberOfCommandsExecuted /
                                  $testResult.CodeCoverage.NumberOfCommandsAnalyzed * 100)
            "Pester code coverage on specified files: ${testCoverage}%"
        }
    }
    finally {
        Remove-Item -Path $TestOutputFile -Force
        Microsoft.PowerShell.Management\Pop-Location
        Remove-Module $env:BHProjectName -ErrorAction SilentlyContinue
    }
}

Task GenerateFileCatalog -depends Build, BuildHelp, CoreGenerateFileCatalog {
}

Task CoreGenerateFileCatalog -requiredVariables CatalogGenerationEnabled, CatalogVersion {
    if (!$CatalogGenerationEnabled) {
        "FileCatalog generation is not enabled. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if (!(Get-Command Microsoft.PowerShell.Security\New-FileCatalog -ErrorAction SilentlyContinue)) {
        "FileCatalog commands not available on this version of PowerShell. Skipping $($psake.context.currentTaskName) task."
        return
    }

    $catalogFilePath = "$env:BHProjectPath\$env:BHProjectName.cat"

    $newFileCatalogParams = @{
        Path = $env:BHPSModulePath
        CatalogFilePath = $catalogFilePath
        CatalogVersion = $CatalogVersion
        Verbose = $VerbosePreference
    }

    Microsoft.PowerShell.Security\New-FileCatalog @newFileCatalogParams > $null

    if ($ScriptSigningEnabled) {
        if ($SharedProperties.CodeSigningCertificate) {
            $setAuthSigParams = @{
                FilePath = $catalogFilePath
                Certificate = $SharedProperties.CodeSigningCertificate
                Verbose = $VerbosePreference
            }

            $result = Microsoft.PowerShell.Security\Set-AuthenticodeSignature @setAuthSigParams
            if ($result.Status -ne 'Valid') {
                throw "Failed to sign file catalog: $($catalogFilePath)."
            }

            "Successfully signed file catalog: $($catalogFilePath)"
        }
        else {
            "No code-signing certificate was found to sign the file catalog."
        }
    }
    else {
        "Script signing is not enabled. Skipping signing of file catalog."
    }

    Move-Item -LiteralPath $newFileCatalogParams.CatalogFilePath -Destination $env:BHPSModulePath
}

Task Publish -depends Build, Test, GenerateFileCatalog, BeforePublish, PublishArtifacts, PublishGallery, AfterPublish {
}

Task PublishArtifacts {
    if (!(Get-Module PSDeploy -ListAvailable)) {
        "PSDeploy module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if ( $env:BHPSModulePath -and $env:BHBuildSystem -eq 'AppVeyor' ) {
        Invoke-PSDeploy -Path $BuildRootDir -Tags AppVeyor -Force -Verbose:$VerbosePreference
    }

}

Task PublishGallery -requiredVariables SettingsPath {
    if (!(Get-Module PSDeploy -ListAvailable)) {
        "PSDeploy module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if ( $env:BHPSModulePath -and $env:BHBuildSystem -ne 'Unknown' -and $env:BHBranchName -eq 'master' ) {
        Invoke-PSDeploy -Path $BuildRootDir -Tags PSGallery -Force -Verbose:$VerbosePreference
    }

}

