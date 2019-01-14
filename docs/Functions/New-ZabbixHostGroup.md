---
external help file: ZabbixTools-help.xml
Module Name: ZabbixTools
online version: https://pszabbixtools.readthedocs.io/en/latest/en-US/New-ZabbixHostGroup
schema: 2.0.0
---

# New-ZabbixHostGroup

## SYNOPSIS
Creates a new host group on the Zabbix server.

## SYNTAX

```
New-ZabbixHostGroup [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-ZabbixHostGroup cmdlet creates a new host groups on the Zabbix server.

## EXAMPLES

### EXAMPLE 1
```
New-ZabbixHostGroup -Name MyGroup
```

Creates a new host group with the name 'MyGroup'.

## PARAMETERS

### -Name
Specifies the name of the groups to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### Int
## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://pszabbixtools.readthedocs.io/en/latest/en-US/New-ZabbixHostGroup](https://pszabbixtools.readthedocs.io/en/latest/en-US/New-ZabbixHostGroup)

