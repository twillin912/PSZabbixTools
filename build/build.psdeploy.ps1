# Publish to gallery with a few restrictions
if(
    $env:BHProjectName -and $env:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq 'stable' -and
    $env:BHCommitMessage -match '!deploy'
)
{
    Deploy Module {
        By PSGalleryModule {
            FromSource $env:BHPSModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $env:NugetApiKey
            }
        }
    }
}

# Publish to AppVeyor if we're in AppVeyor
if(
    $env:BHProjectName -and $env:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -eq 'AppVeyor'
   )
{
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $env:BHPSModulePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}

# Publish to internal gallery
if(
    $env:BHProjectName -and $env:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -eq 'Unknown' -and $env:InternalGallery -and
    $env:NugetApiKey
   )
{
    Deploy Module {
        By PSGalleryModule {
            FromSource $env:BHPSModulePath
            To $env:InternalGallery
            WithOptions @{
                ApiKey = $env:NugetApiKey
            }
        }
    }
}
