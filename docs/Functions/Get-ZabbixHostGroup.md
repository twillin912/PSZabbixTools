---
external help file: ZabbixTools-help.xml
Module Name: ZabbixTools
online version: https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHostGroup
schema: 2.0.0
---

# Get-ZabbixHostGroup

## SYNOPSIS
Gets the host groups from a Zabbix server.

## SYNTAX

```
Get-ZabbixHostGroup [[-GroupId] <Int32[]>] [[-Name] <String>] [-Short] [<CommonParameters>]
```

## DESCRIPTION
The Get-ZabbixHostGroup cmdlet gets the host groups from a Zabbix server.

Without parameters, this cmdlet gets all host groups on the server. 
You can also specify a particular group by group id or group name.

## EXAMPLES

### EXAMPLE 1
```
Get-ZabbixHostGroup
```

Get all host groups on the server.

## PARAMETERS

### -GroupId
Specifies one or more groups by group id.
You can type multiple group ids (separated by commas).

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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

### -Short
Indicates that only the GroupId value it returned. 
This can be useful when piping the output to another command.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Custom.Zabbix.HostGroup
## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHostGroup](https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHostGroup)

