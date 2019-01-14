function ZabbixJsonObject {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$true)]
        [string]$RequestType,

        [Parameter()]
        $Parameters
    )

    Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Creating new request object."
    $RequestObject = New-Object -Type PSObject
    $RequestObject | Add-Member -MemberType NoteProperty -Name 'jsonrpc' -Value '2.0'
    $RequestObject | Add-Member -MemberType NoteProperty -Name 'method' -Value $RequestType
    $RequestObject | Add-Member -MemberType NoteProperty -Name 'params' -Value $Parameters
    if ($RequestType -notmatch 'user.login') {
        $RequestObject | Add-Member -MemberType NoteProperty -Name 'auth' -Value $env:ZabbixAuth
    }
    $RequestObject | Add-Member -MemberType NoteProperty -Name 'id' -Value '1'

    Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Converting request object to JSON format."
    $JsonObject = $RequestObject | ConvertTo-Json -Depth 5 -Compress

    Write-Output -InputObject $JsonObject
}
