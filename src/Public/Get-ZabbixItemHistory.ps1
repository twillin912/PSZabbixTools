function Get-ZabbixItemHistory {
    <#
    .SYNOPSIS
        Gets the item history from a Zabbix server.
    .DESCRIPTION
        The Get-ZabbixItemHistory cmdlet gets the item history from a Zabbix server.

        Without parameters, this cmdlet gets all items on the server.  You can also specify a particular item[s] by item id, host id, item name, or item key.
    .PARAMETER ItemId
        Specifies one or more items by item id. You can type multiple item ids (separated by commas).
    .PARAMETER Last
        Indicates the number of values to return for each item.  By default only the most recent value is returned.
    .EXAMPLE
        Get-ZabbixItemHistory
        Get all items on the server.
    .EXAMPLE
        Get-ZabbixItemHistory -ItemId 100
        Get item data for an item with item id 100
    .EXAMPLE
        Get-ZabbixItemHistory -Name MyServer | Get-ZabbixItem
        Get item data for all items on the host 'MyServer'
    .EXAMPLE
        Get-ZabbixItemHistory -Name "Free Space*"
        Get item data where the name value matches the input string
    .EXAMPLE
        Get-ZabbixItemHistory -Key "vfs.fs.size*"
        Get item data where the key value matches the input string
    .OUTPUTS
        Custom.Zabbix.Item
    .LINK
        https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItemHistory
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]

    Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $ItemId,

        [Parameter(ValueFromPipelineByPropertyName=$true,
                    DontShow=$true)]
        [Alias('value_type')]
        [int] $ValueType,

        [Parameter()]
        [int] $Last = 1,

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
        if ( -not $ValueType ) {
            $ValueType = (Get-ZabbixItem -ItemId $ItemId -Short).value_type
        }

        # Construct the Params variables
        $Params=@{}
        $Params.Add('history', $ValueType)
        $Params.Add('itemids', $ItemId)
        $Params.Add('sortfield', 'clock')
        $Params.Add('sortorder', 'DESC')
        $Params.Add('limit', $Last)

        $Params.Add('output', 'extend')


        $JsonRequest = ZabbixJsonObject -RequestType 'history.get' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n`t$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        try {
            $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' -Certificate $Certificate -ErrorAction Stop
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
                    $Object.PSObject.TypeNames.Insert(0, 'Custom.Zabbix.ItemHistory')
                }
            }
            Write-Output -InputObject $OutputObject
        }
        else {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No item history entries found matching the specified criteria."
        }

    } # End

} # function Get-ZabbixItemHistory
