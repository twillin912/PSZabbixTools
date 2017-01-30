function Get-ZabbixItem {
    <#
    .SYNOPSIS
        Gets the items from a Zabbix server.
    .DESCRIPTION
        The Get-ZabbixItem cmdlet gets the items from a Zabbix server.

        Without parameters, this cmdlet gets all items on the server.  You can also specify a particular item[s] by item id, host id, item name, or item key.
    .PARAMETER ItemId
        Specifies one or more items by item id. You can type multiple item ids (separated by commas).
    .PARAMETER HostId
        Specifies one or more items by host id. You can type multiple host ids (separated by commas).
    .PARAMETER Name
        Specifies one or more items by item name.  You can use wildcard characters.
    .PARAMETER Key
        Specifies one or more items by item key.  You can use wildcard characters.
    .PARAMETER Short
        Indicates that only the ItemId and ValueType values are returned.  This can be useful when piping the output to another command.
    .EXAMPLE
        Get-ZabbixItem
        Get all items on the server.
    .EXAMPLE
        Get-ZabbixItem -ItemId 100,101
        Get data for items with id 100 or 101
    .EXAMPLE
        Get-ZabbixHost -Name MyServer | Get-ZabbixItem
        Get item data for all items on the host 'MyServer'
    .EXAMPLE
        Get-ZabbixItem -Name "Free Space*"
        Get item data where the name value matches the input string
    .EXAMPLE
        Get-ZabbixItem -Key "vfs.fs.size*"
        Get item data where the key value matches the input string
    .OUTPUTS
        Custom.Zabbix.Item
    .LINK
        https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItem
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]

    Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $ItemId,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $HostId,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [string] $Key,

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
        if ( $ItemId ) {
            $Params.Add('itemids', $ItemId)
        }

        if ( $HostId ) {
            $Params.Add('hostids', $HostId)
        }

        if ( $Name ) {
            $Search.Add('name', $Name)
        }

        if ( $Key ) {
            $Search.Add('key_', $Key)
        }

        if ( $Search ) {
            $Params.Add('search', $Search)
            $Params.Add('searchWildcardsEnabled', $true)
        }

        if ( $Short ) {
            $Params.Add('output', @('itemid','value_type'))
        } else {
            $Params.Add('output', 'extend')
        }

        $JsonRequest = ZabbixJsonObject -RequestType 'item.get' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n`t$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        try {
            $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' -ErrorAction Stop
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
                    $Object.PSObject.TypeNames.Insert(0, 'Custom.Zabbix.Item')
                }
            }
            Write-Output -InputObject $OutputObject
        }
        else {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No item entries found matching the specified criteria."
        }

    } # End

} # function Get-ZabbixItem

