function Get-ZabbixHost {
    <#
    .SYNOPSIS
        Gets the hosts from a Zabbix server.
    .DESCRIPTION
        The Get-ZabbixHost cmdlet gets the hosts from a Zabbix server.

        Without parameters, this cmdlet gets all hosts on the server.  You can also specify a particular host by host id, group id, or host name.
    .PARAMETER HostId
        Specifies one or more hosts by host id. You can type multiple host ids (separated by commas).
    .PARAMETER GroupId
        Specifies one or more hosts by group id. You can type multiple group ids (separated by commas).
    .PARAMETER TemplateId
        Specifies one or more hosts by template id. You can type multiple template ids (separated by commas).
    .PARAMETER Name
        Specifies one or more hosts by host name.  You can use wildcard characters.
    .PARAMETER Short
        Indicates that only the HostId value it returned.  This can be useful when piping the output to another command.
    .EXAMPLE
        Get-ZabbixHost
        Get all hosts on the server.
    .EXAMPLE
        Get-ZabbixHost -HostName 'Server01'
        In this example we are searching for any hosts where the 'host' field match the search input.
    .EXAMPLE
        Get-ZabbixHost -HostId 10000,10001,10002
        Retrieve host(s) by Id
    .EXAMPLE
        Get-ZabbixHostGroup -Name MyGroup | Get-ZabbixHost
        Get all hosts the belong to the host group 'MyGroup'
    .EXAMPLE
        Get-ZabbixTemplate -Name Template01 | Get-ZabbixHost
        Get all hosts the have the template 'Template01' applied
    .OUTPUTS
        Custom.Zabbix.Host
    .LINK
        https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHost
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]

    Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $HostId,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $GroupId,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $TemplateId,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [switch] $Short
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
        if ( $HostId ) {
            $Params.Add('hostids', $HostId)
        }

        if ( $GroupId ) {
            $Params.Add('groupids', $GroupId)
        }

        if ( $TemplateId ) {
            $Params.Add('templateids', $TemplateId)
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
            $Params.Add('selectGroups', 'extend')
        }

        $JsonRequest = ZabbixJsonObject -RequestType 'host.get' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        try {
            $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' -ErrorAction Stop
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
                    Add-Member -InputObject $Object -MemberType NoteProperty -Name groupnames -Value $Object.Groups.Name
                    $Object.PSObject.TypeNames.Insert(0, 'Custom.Zabbix.Host')
                }
            }
            Write-Output -InputObject $OutputObject
        }
        else {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No host entries found matching the specified criteria."
        }

    } # End

} # function Get-ZabbixHost

