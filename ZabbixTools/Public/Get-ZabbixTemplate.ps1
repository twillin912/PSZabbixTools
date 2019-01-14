function Get-ZabbixTemplate {
    <#
    .SYNOPSIS
        Gets the templates from a Zabbix server.
    .DESCRIPTION
        The Get-ZabbixTemplate cmdlet gets the templates from a Zabbix server.

        Without parameters, this cmdlet gets all templates on the server.  You can also specify a particular template by template id, group id, or template name.
    .PARAMETER TemplateId
        Specifies one or more templates by template id. You can type multiple template ids (separated by commas).
    .PARAMETER GroupId
        Specifies one or more templates by group id. You can type multiple group ids (separated by commas).
    .PARAMETER Name
        Specifies one or more templates by template name.  You can use wildcard characters.
    .PARAMETER Short
        Indicates that only the TemplateId value it returned.  This can be useful when piping the output to another command.
    .EXAMPLE
        Get-ZabbixTemplate
        Get all templates on the server.
    .EXAMPLE
        Get-ZabbixTemplate -TemplateId 10000,10001
        Get data for templates with id 10000 or 10001
    .EXAMPLE
        Get-ZabbixTemplate -Name 'Template01'
        Get template data where the template name matches the input value.
    .EXAMPLE
        Get-ZabbixHostGroup -Name MyGroup | Get-ZabbixTemplate
        Get template data for all templates in the group 'Group01'
    .OUTPUTS
        Custom.Zabbix.Template
    .LINK
        https://pszabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixTemplate
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]

    Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $TemplateId,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int[]] $GroupId,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [switch] $Short
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
        $Params=@{}
        $Search=@{}

        # Construct the Params and Search variables
        if ( $TemplateId ) {
            $Params.Add('templateids', $HostId)
        }

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
            $Params.Add('selectGroups', 'extend')
        }

        $JsonRequest = ZabbixJsonObject -RequestType 'template.get' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n`t$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        try {
            $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' @ZabbixCert -ErrorAction Stop
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
                    $Object.PSObject.TypeNames.Insert(0, 'Custom.Zabbix.Template')
                }
            }
            Write-Output -InputObject $OutputObject
        }
        else {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No template entries found matching the specified criteria."
        }

    } # End

} # function Get-ZabbixHost

