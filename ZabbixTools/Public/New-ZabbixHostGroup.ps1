function New-ZabbixHostGroup {
    <#
    .SYNOPSIS
        Creates a new host group on the Zabbix server.
    .DESCRIPTION
        The New-ZabbixHostGroup cmdlet creates a new host groups on the Zabbix server.
    .PARAMETER Name
        Specifies the name of the groups to create.
    .EXAMPLE
        New-ZabbixHostGroup -Name MyGroup
        Creates a new host group with the name 'MyGroup'.
    .OUTPUTS
        Int
    .LINK
        https://pszabbixtools.readthedocs.io/en/latest/en-US/New-ZabbixHostGroup
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([int])]

    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
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
    }

    Process {
        $Params = @{}

        # Construct the Params variable
        $Params.Add('name', $Name)

        $JsonRequest = ZabbixJsonObject -RequestType 'hostgroup.create' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        if ( $PSCmdlet.ShouldProcess("Create host group '$Name'") ) {
            try {
                $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' @ZabbixCert -ErrorAction Stop
                Write-Verbose -Message "$JsonResponse"
            }
            catch {
                Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
                Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
                break
            }
            if ( $JsonResponse.Error ) {
                Write-Error -Message $JsonResponse.Error.Data
            } else {
                $JsonResponse.Result.GroupIds
            }
        }

    } # Process

    End {
    } # End

} # function New-ZabbixHostGroup

