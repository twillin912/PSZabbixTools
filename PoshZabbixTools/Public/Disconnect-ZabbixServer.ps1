function Disconnect-ZabbixServer {
    <#
    .SYNOPSIS
        Sends a logout request to a Zabbix server API service.
    .DESCRIPTION
        The Disconnect-ZabbixServer function sends a logout request to the Zabbix server API and removes the local session information.
    .EXAMPLE
        Disconnect-ZabbixServer
    .INPUTS
        This function requires no inputs.
    .OUTPUTS
        This function provides no outputs.
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    .LINK
        https://poshzabbixtools.readthedocs.io/en/latest/Commands/Disconnect-ZabbixServer
    #>
    [CmdletBinding()]

    Param(
    )

    if (!($env:ZabbixUri)) {
        Write-Warning -Message '$($MyInvocation.MyCommand.Name): No action sessions found.'
        break
    }

    $Params=@{}

    $JsonRequest = ZabbixJsonObject -RequestType 'user.logout' -Parameters $Params
    Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

    try {
        $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' -ErrorAction Stop
        Remove-Item -Name env:ZabbixAuth -ErrorAction SilentlyContinue
        Remove-Item -Name env:ZabbixUri -ErrorAction SilentlyContinue
        Write-Verbose -Message "$JsonResponse"
    }
    catch {
        Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
        Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
        break
    }


}
