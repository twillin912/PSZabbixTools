Write-Verbose -Message 'Importing functions'
foreach ( $Folder in @('Private','Public') )
{
    $Root = Join-Path -Path $PSScriptRoot -ChildPath $Folder
    if ( Test-Path -Path $Root )
    {
        Write-Verbose -Message "Processing folder $Root"
        $Files = Get-ChildItem -Path $Root -Filter *.ps1 -Recurse -File

        foreach ( $File in $Files )
        {
            . $File.FullName
        }
    }
}

#Export only the functions in the Public folder.
Export-ModuleMember -Function ( Get-ChildItem -Path "$PSScriptRoot\Public*.ps1").Basename
