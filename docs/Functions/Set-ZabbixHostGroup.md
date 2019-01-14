---
external help file: ZabbixTools-help.xml
Module Name: ZabbixTools
online version: https://pszabbixtools.readthedocs.io/en/latest/en-US/Set-ZabbixHostGroup
schema: 2.0.0
---

# Set-ZabbixHostGroup

## SYNOPSIS
Gets the host groups from a Zabbix server.

## SYNTAX

```
Set-ZabbixHostGroup [[-Identity] <Int32>] [[-Name] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Get-ZabbixHostGroup cmdlet gets the host groups from a Zabbix server.

Without parameters, this cmdlet gets all host groups on the server.
You can also specify a particular group by group id or group name.

## EXAMPLES

### EXAMPLE 1
```
Set-ZabbixHostGroup -Identity 100 -Name MyGroup
```

Get all host groups on the server.

## PARAMETERS

### -Identity
Specifies one or more groups by group id.
You can type multiple group ids (separated by commas).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: GroupId

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies one or more groups by group name.
You can use wildcard characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None
## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://pszabbixtools.readthedocs.io/en/latest/en-US/Set-ZabbixHostGroup](https://pszabbixtools.readthedocs.io/en/latest/en-US/Set-ZabbixHostGroup)

