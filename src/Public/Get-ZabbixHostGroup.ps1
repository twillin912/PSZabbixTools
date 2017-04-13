function Get-ZabbixHostGroup {
    <#
    .SYNOPSIS
        Gets the host groups from a Zabbix server.
    .DESCRIPTION
        The Get-ZabbixHostGroup cmdlet gets the host groups from a Zabbix server.

        Without parameters, this cmdlet gets all host groups on the server.  You can also specify a particular group by group id or group name.
    .PARAMETER GroupId
        Specifies one or more groups by group id. You can type multiple group ids (separated by commas).
    .PARAMETER Name
        Specifies one or more groups by group name.  You can use wildcard characters.
    .PARAMETER Short
        Indicates that only the GroupId value it returned.  This can be useful when piping the output to another command.
    .EXAMPLE
        Get-ZabbixHostGroup
        Get all host groups on the server.
    .OUTPUTS
        Custom.Zabbix.HostGroup
    .LINK
        https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHostGroup
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]

    Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $GroupId,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [switch] $Short,

        $Certificate = $Global:Certificate
    )

    Begin {
        if (!($env:ZabbixUri)) {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No session information found. Use 'Connect-ZabbixServer' to login and create your Api session."
            break;
        }

        $OutputObject = @()

    }

    Process {
        $Params=@{}
        $Search=@{}

        # Construct the Params and Search variables
        if ( $GroupId ) {
            $Params.Add('groupids', $GroupId)
        }

        if ( $Name ) {
            $Search.Add('name', $Name)
        }

        if ( $Search ) {
            $Params.Add('search', $Search)
            $Params.Add('searchWildcardsEnabled', $true)
        }

        if ( $Short ) {
            $Params.Add('output', 'short')
        } else {
            $Params.Add('output', 'extend')
        }

        $JsonRequest = ZabbixJsonObject -RequestType 'hostgroup.get' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        try {
            $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' -Certificate $Certificate -ErrorAction Stop
            Write-Verbose -Message "$JsonResponse"
        }
        catch {
            Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
            Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
            break
        }

        $OutputObject += $JsonResponse.Result
    } # Process

    End {
        if ( $OutputObject.Count -ne 0 ) {
            if ( -not $Short ) {
                foreach ( $Object in $OutputObject ) {
                $Object.PSObject.TypeNames.Insert(0, 'Custom.Zabbix.HostGroup')
                }
            }
            Write-Output -InputObject $OutputObject
        }
        else {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No group entries found matching the specified criteria."
        }

    } # End

} # function Get-ZabbixHostGroup

