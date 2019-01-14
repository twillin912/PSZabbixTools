function Remove-ZabbixItem {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [int[]] $ItemId
    )

    begin {
        if (!($env:ZabbixAuth)) {
            Write-Warning -Message "$($MyInvocation.MyCommand.Name): No session information found. Use 'Connect-ZabbixServer' to login and create your Api session."
            break
        }

        # Build hashtable to splat certificate into RestMethod function
        $ZabbixCert = @{}
        if ( $env:ZabbixCert ) {
            $ZabbixCert.Add('Certificate', $env:ZabbixCert)
        }
        $ItemList = @()
        $OutputObject = @()
    }

    process {
        $ItemList += $ItemId
    }

    end {
        $JsonRequest = ZabbixJsonObject -RequestType 'item.delete' -Parameters $ItemList
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Sending JSON request object`n`t$($JsonRequest -Replace $env:ZabbixAuth, 'XXXXXX')"

        if ( $PSCmdlet.ShouldProcess($Params, 'Remove') ) {
            try {
                $JsonResponse = Invoke-RestMethod -Uri $env:ZabbixUri -Method Put -Body $JsonRequest -ContentType 'application/json' @ZabbixCert -ErrorAction Stop
            }
            catch {
                Write-Warning "At line:$($_.InvocationInfo.ScriptLineNumber) char:$($_.InvocationInfo.OffsetInLine) Command:$($_.InvocationInfo.InvocationName), Exception: '$($_.Exception.Message.Trim())'"
                break
            }
        }
        $OutputObject += $JsonResponse.Result
        if ( $OutputObject.Count -ne 0 ) {
            Write-Output -InputObject $OutputObject
        }
    }
}
