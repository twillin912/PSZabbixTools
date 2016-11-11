Deploy Module {
    By PSGalleryModule {
        FromSource $env:BHPSModulePath
        To PSGallery
        Tagged PSGallery
        WithOptions @{
            ApiKey = $env:NugetApiKey
        }
    }
}

Deploy DeveloperBuild {
    By AppVeyorModule {
        FromSource $env:BHPSModulePath
        To AppVeyor
        Tagged AppVeyor
        WithOptions @{
            Version = $env:APPVEYOR_BUILD_VERSION
        }
    }
}