#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    foreach ( $Import in @($Public + $Private))
    {
        try
        {
            . $Import.fullname
        }
        catch
        {
            Write-Error -Message "Failed to import function $($Import.fullname): $_"
        }
}

#Export only the functions in the Public folder.
Export-ModuleMember -Function $Public.Basename