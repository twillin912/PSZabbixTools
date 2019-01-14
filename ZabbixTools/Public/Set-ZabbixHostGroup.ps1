function Set-ZabbixHostGroup {
    <#
    .SYNOPSIS
        Gets the host groups from a Zabbix server.
    .DESCRIPTION
        The Get-ZabbixHostGroup cmdlet gets the host groups from a Zabbix server.

        Without parameters, this cmdlet gets all host groups on the server.  You can also specify a particular group by group id or group name.
    .PARAMETER Identity
        Specifies one or more groups by group id. You can type multiple group ids (separated by commas).
    .PARAMETER Name
        Specifies one or more groups by group name.  You can use wildcard characters.
    .EXAMPLE
        Set-ZabbixHostGroup -Identity 100 -Name MyGroup
        Get all host groups on the server.
    .OUTPUTS
        None
    .LINK
        https://poshzabbixtools.readthedocs.io/en/latest/en-US/Set-ZabbixHostGroup
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSObject])]

    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupId')]
        [int] $Identity,

        [Parameter()]
        [string] $Name
    )

    Begin {
        if (!($env:ZabbixAuth)) {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No session information found. Use 'Connect-ZabbixServer' to login and create your Api session."
            break;
        }

        # Build hashtable to splat certificate into RestMethod function
        $ZabbixCert = @{}
        if ( $env:ZabbixCert ) {
            $ZabbixCert.Add('Certificate', $env:ZabbixCert)
        }

        $OutputObject = @()

    }

    Process {
        $Params = @{}
        $Search = @{}

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
        }
        else {
            $Params.Add('output', 'extend')
        }

        $JsonRequest = ZabbixJsonObject -RequestType 'hostgroup.get' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        if ( $PSCmdlet.ShouldProcess('') ) {
            try {
                $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' @ZabbixCert -ErrorAction Stop
                Write-Verbose -Message "$JsonResponse"
            }
            catch {
                Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
                Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
                break
            }
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

