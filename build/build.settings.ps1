Param(
    [Parameter(Mandatory=$true)]
    [string] $ProjectRoot
)

###############################################################################
# Customize these properties and tasks for your module.
###############################################################################

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ArtifactPath = Join-Path -Path $ProjectRoot -ChildPath 'artifacts'

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$BuildPath = Join-Path -Path $ProjectRoot -ChildPath 'build'

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$DocsPath = Join-Path -Path $ProjectRoot -ChildPath 'docs'

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$TestPath = Join-Path -Path $ProjectRoot -ChildPath 'tests'

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$PesterResultsFile = Join-Path -Path $ArtifactPath -ChildPath 'PesterResults.xml'

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$UseAppVeyor = $false

$Version = (Test-ModuleManifest -Path "$env:BHPSModuleManifest").Version
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ModuleVersion = New-Object -TypeName Version -ArgumentList $Version.Major, $Version.Minor, $Version.Build

###############################################################################
# Before/After Hooks for the Core Task: Clean
###############################################################################

# SYNOPSIS: Executes before the Clean task.
#Add-BuildTask BeforeClean -Before Clean {}

# SYNOPSIS: Executes after the Clean task.
#Add-BuildTask AfterClean -After Clean {}

###############################################################################
# Before/After Hooks for the Core Task: Analyze
###############################################################################

# SYNOPSIS: Executes before the Analyze task.
#Add-BuildTask BeforeAnalyze -Before Analyze {}

# SYNOPSIS: Executes after the Analyze task.
#Add-BuildTask AfterAnalyze -After Analyze {}

###############################################################################
# Before/After Hooks for the Core Task: Build
###############################################################################

# SYNOPSIS: Executes before the Test Task.
#Add-BuildTask BeforeBuild -Before Build {}

# SYNOPSIS: Executes after the Test Task.
#Add-BuildTask AfterBuild -After Build {}

###############################################################################
# Before/After Hooks for the Core Task: Test
###############################################################################

# SYNOPSIS: Executes before the Test Task.
#Add-BuildTask BeforeTest -Before Test {}

# SYNOPSIS: Executes after the Test Task.
#Add-BuildTask AfterTest -After Test {}

###############################################################################
# Before/After Hooks for the Core Task: Archive
###############################################################################

# SYNOPSIS: Executes before the Archive task.
#Add-BuildTask BeforeArchive -Before Archive {}

# SYNOPSIS: Executes after the Archive task.
#Add-BuildTask AfterArchive -After Archive {}

###############################################################################
# Before/After Hooks for the Core Task: Publish
###############################################################################

# SYNOPSIS: Executes before the Publish task.
#Add-BuildTask BeforePublish -Before Publish {}

# SYNOPSIS: Executes after the Publish task.
#Add-BuildTask AfterPublish -After Publish {}
