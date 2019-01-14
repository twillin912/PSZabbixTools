#Requires -Modules InvokeBuild

###############################################################################
# Dot source the user's customized properties and extension tasks.
###############################################################################
. $env:BHProjectPath\build\build.settings.ps1 -ProjectRoot $env:BHProjectPath
. $env:BHProjectPath\module.settings.ps1

Set-StrictMode -Version Latest

# SYNOPSIS: Default build task
Add-BuildTask . Init, Clean, Build, BuildHelp, Analyze, Test

Add-BuildTask Init {
    $FileVersion = (Test-ModuleManifest -Path "$env:BHPSModuleManifest").Version
    $ModuleVersion = New-Object -TypeName Version -ArgumentList $FileVersion.Major, $FileVersion.Minor, $FileVersion.Build, ($FileVersion.Revision + 1)
    $env:BHBuildNumber = $ModuleVersion.Revision
    $env:BHModuleVersion = $ModuleVersion.ToString()

    New-Item -Path "$ArtifactPath" -ItemType Directory -Force | Out-Null

    if ($env:BHBuildSystem -eq 'AppVeyor') {
        Update-AppveyorBuild -Version $env:BHModuleVersion
    }
}

# SYNOPSIS: Clean artifacts directory
Add-BuildTask Clean Init, {

    Get-ChildItem -Path $ArtifactPath | Remove-Item -Recurse -Force -Verbose:$VerbosePreference

    Get-Module -Name $env:BHProjectName | Remove-Module -Force
}



Add-BuildTask Analyze PSParser, PSAnalyzer

# SYNOPSIS: Lint code with PSScriptAnalyzer
Add-BuildTask PSParser {
    Get-ChildItem -Path $env:BHPSModulePath -Filter '*.ps1' -Exclude '*.Format.ps1xml' -Recurse | ForEach-Object {
        $Errors = $null
        $FileContent = Get-Content -Path $_.FullName -ErrorAction Stop
        [System.Management.Automation.PSParser]::Tokenize($FileContent, [ref]$Errors) | Out-Null
        if ($Errors) {
            $_.Name
            $Errors | Format-List
            throw 'One or more PSParser errors/warnings were found.'
        }
    }
}

# SYNOPSIS: Lint code with PSScriptAnalyzer
Add-BuildTask PSAnalyzer {
    $AnalyzeResults = Invoke-ScriptAnalyzer -Path $env:BHPSModulePath -Recurse -Settings "$BuildPath\scriptanalyzer.settings.psd1"
    $AnalyzeResults | ConvertTo-Json | Set-Content (Join-Path $ArtifactPath 'ScriptAnalysisResults.json')

    if ($AnalyzeResults) {
        $AnalyzeResults | Format-Table
        throw 'One or more PSScriptAnalyzer errors/warnings where found.'
    }
}



# SYNOPSIS:
Add-BuildTask Build {
    $Functions = Get-ChildItem -Path "$env:BHPSModulePath/Public" -Filter *.ps1 -Recurse
    $Formats = Get-ChildItem -Path "$env:BHPSModulePath/Formats" -Filter *.Format.ps1xml -Recurse

    $ManifestParams = @{}
    $ManifestParams.Add('ModuleVersion', $env:BHModuleVersion)
    if ($Functions) {
        $ManifestParams.Add('FunctionsToExport', $Functions.BaseName)
    }
    if ($Formats) {
        $ManifestParams.Add('FormatsToProcess',
            ($Formats | ForEach-Object {"Formats/$($_.Name)"})
        )
    }

    if ($Author) {
        $ManifestParams.Add('Author', $Author)
    }
    if ($Description) {
        $ManifestParams.Add('Description', $Description)
    }
    if ($ProjectUri) {
        $ManifestParams.Add('ProjectUri', $ProjectUri)
    }
    if ($LicenseUri) {
        $ManifestParams.Add('LicenseUri', $LicenseUri)
    }
    if ($ReleaseNotes) {
        $ManifestParams.Add('ReleaseNotes', $ReleaseNotes)
    }
    if ($Tags) {
        $ManifestParams.Add('Tags', $Tags)
    }

    Update-ModuleManifest -Path "$env:BHPSModuleManifest" @ManifestParams
    $ManifestContent = Get-Content -Path "$env:BHPSModuleManifest"
    $ManifestContent = $ManifestContent | ForEach-Object { $_.TrimEnd() }
    Set-Content -Path "$env:BHPSModuleManifest" -Value $ManifestContent

}



# SYNOPSIS: Build help files with PlatyPS
Add-BuildTask BuildHelp MarkdownHelp, ExternalHelp

# SYNOPSIS: Create markdown help from module
Add-BuildTask MarkdownHelp {
    $ModuleInfo = Import-Module $env:BHPSModuleManifest -Global -Force -PassThru

    try {
        if ($ModuleInfo.ExportedCommands.Count -eq 0) {
            Write-Warning -Message ('No commands have been exported. Skipping "{0}" task.' -f $Task.Name)
            return
        }

        if (!(Test-Path -LiteralPath $DocsPath)) {
            New-Item -Path $DocsPath -ItemType Directory | Out-Null
        }

        $HelpParams = @{
            Module         = $env:BHProjectName
            Locale         = 'en-US'
            OutputFolder   = "$DocsPath/Functions"
            WithModulePage = $false
            HelpVersion    = $env:BHModuleVersion
        }

        PlatyPS\New-MarkdownHelp @HelpParams -Force -Verbose:$VerbosePreference | Out-Null

        if (Get-ChildItem -LiteralPath $DocsPath -Filter *.md -Recurse) {
            Get-ChildItem -LiteralPath $DocsPath -Directory -Recurse | ForEach-Object {
                PlatyPS\Update-MarkdownHelp -Path $_.FullName -Verbose:$VerbosePreference | Out-Null
            }
        }
    }
    finally {
        Remove-Module $env:BHProjectName
    }
}

# SYNOPSIS:
Add-BuildTask ExternalHelp {
    if (!(Get-ChildItem -LiteralPath $DocsPath -Filter *.md -Recurse -ErrorAction SilentlyContinue)) {
        Write-Warning -Message ('No markdown help files to process. Skipping "{0}" task.' -f $Task.Name)
        return
    }

    $HelpSource = @($DocsPath)
    if (Test-Path -Path (Join-Path -Path $DocsPath -ChildPath 'Functions') ) {
        $HelpSource += Join-Path -Path $DocsPath -ChildPath 'Functions'
    }

    New-ExternalHelp -Path $HelpSource -Force -OutputPath "$env:BHPSModulePath/en-US" | Out-Null
}



# SYNOPSIS: Run/Publish Tests and Fail Build on Error
Add-BuildTask Test RunTest, ConfirmTests

# SYNOPSIS: Run unit testing with Pester
Add-BuildTask RunTest {
    if (!(Get-Module Pester -ListAvailable)) {
        "Pester module is not installed. Skipping $Task task."
        return
    }

    Import-Module -Name Pester

    try {
        Microsoft.PowerShell.Management\Push-Location -LiteralPath $TestPath

        $PesterParams = @{
            OutputFile   = $PesterResultsFile
            OutputFormat = 'NUnitXml'
            Strict       = $true
            PassThru     = $true
            EnableExit   = $false
            CodeCoverage = (Get-ChildItem -Path "$env:BHPSModulePath/*.ps1" -Recurse)
        }

        $PesterResults = Invoke-Pester @PesterParams
        $PesterResults | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $ArtifactPath 'PesterResults.json')

        if ($env:BHBuildSystem -eq 'AppVeyor') {
            [xml]$PesterXml = Get-Content -Path $PesterResultsFile
            $PesterXml.'test-results'.'test-suite'.type = 'PowerShell'
            $PesterXml.Save($PesterResultsFile)

            $WebClient = New-Object -TypeName System.Net.WebClient
            $WebClient.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path -Path $PesterResultsFile))
        }
    }
    finally {
        Microsoft.PowerShell.Management\Pop-Location
    }
}

# SYNOPSIS:Throws and error if any tests do not pass for CI usage
Add-BuildTask ConfirmTests {
    [Xml] $PesterXml = Get-Content -Path $PesterResultsFile
    $FailCount = $PesterXml.'Test-Results'.Failures
    Assert-Build ($FailCount -eq 0) ('Failed "{0}" unit tests.' -f $FailCount)
}

# SYNOPSIS: Publish Module using PSDeploy
Add-BuildTask Publish Build, BuildHelp, Test {
    # $NewBuild = New-Object -TypeName Version -ArgumentList $ModuleVersion.Major, $ModuleVersion.Minor, ($ModuleVersion.Build + 1)
    # Update-ModuleManifest -Path "$env:BHPSModuleManifest" -ModuleVersion $NewBuild

    $PublishParams = @{
        Path    = "$env:BHProjectPath/build"
        Force   = $true
        Recurse = $false
    }

    Invoke-PSDeploy @PublishParams
}
