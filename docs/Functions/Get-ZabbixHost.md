---
external help file: ZabbixTools-help.xml
Module Name: ZabbixTools
online version: https://pszabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHost
schema: 2.0.0
---

# Get-ZabbixHost

## SYNOPSIS
Gets the hosts from a Zabbix server.

## SYNTAX

```
Get-ZabbixHost [[-Identity] <Int32[]>] [[-Name] <String>] [[-GroupId] <Int32[]>] [[-TemplateId] <Int32[]>]
 [-Short] [<CommonParameters>]
```

## DESCRIPTION
The Get-ZabbixHost cmdlet gets the hosts from a Zabbix server.

Without parameters, this cmdlet gets all hosts on the server. 
You can also specify a particular host by host id, group id, or host name.

## EXAMPLES

### EXAMPLE 1
```
Get-ZabbixHost
```

Get all hosts on the server.

### EXAMPLE 2
```
Get-ZabbixHost -HostName 'Server01'
```

In this example we are searching for any hosts where the 'host' field match the search input.

### EXAMPLE 3
```
Get-ZabbixHost -Identity 10000,10001,10002
```

Retrieve host(s) by Id

### EXAMPLE 4
```
Get-ZabbixHostGroup -Name MyGroup | Get-ZabbixHost
```

Get all hosts the belong to the host group 'MyGroup'

### EXAMPLE 5
```
Get-ZabbixTemplate -Name Template01 | Get-ZabbixHost
```

Get all hosts the have the template 'Template01' applied

## PARAMETERS

### -Identity
Specifies one or more hosts by host id.
You can type multiple host ids (separated by commas).

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: HostId

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies one or more hosts by host name. 
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

### -GroupId
Specifies one or more hosts by group id.
You can type multiple group ids (separated by commas).

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TemplateId
Specifies one or more hosts by template id.
You can type multiple template ids (separated by commas).

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Short
Indicates that only the Identity value it returned. 
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

### Custom.Zabbix.Host
## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://pszabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHost](https://pszabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixHost)

