#Get public and private function definition files.
$Public  = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue
$Private = Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue
If ( $Public ) {$AllFunctions += $Public}
If ( $Private ) {$AllFunctions += $Public}

#Dot source the files
foreach ( $Import in $AllFunctions ) {
    try {
        . $Import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

# Export only the functions in the Public folder.
Export-ModuleMember -Function $Public.Basename
