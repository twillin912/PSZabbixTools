$Functions  = @( Get-ChildItem -Path $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach ( $Import in $Functions ) {
    try {
        . $Import.Fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($Import.fullname): $_"
    }
}

# Export only the functions using PowerShell standard verb-noun naming.
Export-ModuleMember -Function *-*
