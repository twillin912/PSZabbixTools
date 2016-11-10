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
        https://github.com/twillin912/PoshZabbixTools
    #>
	[CmdletBinding()]

	Param(
	)

	if ( -not $ZabbixSession ) {
		Write-Warning -Message '$($MyInvocation.MyCommand.Name): No action sessions found.'
		break
	}

	$Params=@{}

	$JsonRequest = ZabbixJsonObject -RequestType 'user.logout' -Parameters $Params
	Write-Verbose -Message "Sending JSON request object`n$($JsonRequest -Replace $ZabbixSession.AuthId, 'XXXXXX')"

	try {
		$JsonResponse = Invoke-RestMethod -Uri $($ZabbixSession.Uri) -Method Put -Body $JsonRequest -ContentType 'application/json' -ErrorAction Stop
		Write-Verbose -Message "$JsonResponse"
	}
	catch {
		Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
		Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
		break
	}

	Remove-Variable -Name ZabbixSession -Scope Global
}
