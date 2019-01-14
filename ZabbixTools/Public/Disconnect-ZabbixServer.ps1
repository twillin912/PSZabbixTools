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
        https://poshzabbixtools.readthedocs.io/en/latest/en-US/Disconnect-ZabbixServer
    #>
    [CmdletBinding()]

    Param(

    )

    if (!($env:ZabbixAuth)) {
        Write-Warning -Message "$($MyInvocation.MyCommand.Name): No active sessions found."
        break
    }

    # Build hashtable to splat certificate into RestMethod function
    $ZabbixCert = @{}
    if ( $env:ZabbixCert ) {
        $ZabbixCert.Add('Certificate', $env:ZabbixCert)
    }

    $Params = @{}

    $JsonRequest = ZabbixJsonObject -RequestType 'user.logout' -Parameters $Params
    Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

    try {
        $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' @ZabbixCert -ErrorAction Stop
        Remove-Item -Path env:ZabbixAuth -ErrorAction SilentlyContinue
        Remove-Item -Path env:ZabbixUri -ErrorAction SilentlyContinue
        Remove-Item -Path env:ZabbixCert -ErrorAction SilentlyContinue
        Write-Verbose -Message "$JsonResponse"
        if ($JsonResponse.result -eq $true) {
            Write-Verbose -Message 'Logout successful'
        }
        else {
            Write-Warning -Message 'Logout not successful'
        }
    }
    catch {
        Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
        Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
        break
    }


}
