function Export-ZabbixConfiguration {
    <#
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias(
            'GroupId','HostId','TemplateId'
        )]
        [int[]] $Identity,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet(
            'Groups','Hosts','Screens','Templates','ValueMaps'
        )]
        [string] $Type
    )

    begin {
                if (!($env:ZabbixUri)) {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No session information found. Use 'Connect-ZabbixServer' to login and create your Api session."
            break;
        }

        # Build hashtable to splat certificate into RestMethod function
        $ZabbixCert = @{}
        if ( $env:ZabbixCert ) {
            $ZabbixCert.Add('Certificate', $env:ZabbixCert)
        }

        #$OutputObject = @()
    }

    process {
        $Params = @{}
        $TypeGroup = @{}
        $TypeGroup.Add($Type.ToLower(),$Identity -join ',')
        $Params.Add('options', $TypeGroup)
        $Params.Add('format', 'xml')

        $JsonRequest = ZabbixJsonObject -RequestType 'configuration.export' -Parameters $Params
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        try {
            $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' @ZabbixCert -ErrorAction Stop
            #Write-Verbose -Message "$JsonResponse"
        }
        catch {
            Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"
            Write-Error "StatusDescription: $($_.Exception.Response.StatusDescription)"
            break
        }

        $JsonResponse.Result

    }

    end {}

}
