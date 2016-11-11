---
external help file: PoshZabbixTools-help.xml
online version: https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixTemplate
schema: 2.0.0
---

# Get-ZabbixTemplate

## SYNOPSIS
Gets the hosts from a Zabbix server.

## SYNTAX

```
Get-ZabbixTemplate [[-TemplateId] <Int32[]>] [[-GroupId] <Int32[]>] [[-Name] <String>] [-Short]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-ZabbixHost cmdlet gets the hosts from a Zabbix server.

Without parameters, this cmdlet gets all hosts on the server. 
You can also specify a particular host by host id, group id, or host name.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ZabbixTemplate
```

Get all templates on the server.

### -------------------------- EXAMPLE 2 --------------------------
```
Get-ZabbixTemplate -TemplateId 10000,10001
```

Get data for templates with id 10000 or 10001

### -------------------------- EXAMPLE 3 --------------------------
```
Get-ZabbixTemplate -Name 'Template01'
```

Get template data where the template name matches the input value.

### -------------------------- EXAMPLE 4 --------------------------
```
Get-ZabbixHostGroup -Name MyGroup | Get-ZabbixTemplate
```

Get template data for all templates in the group 'Group01'

## PARAMETERS

### -TemplateId
{{Fill TemplateId Description}}

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

### -GroupId
Specifies one or more hosts by group id.
You can type multiple group ids (separated by commas).

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Short
Indicates that only the HostId value it returned. 
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

### Custom.Zabbix.Template

## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixTemplate](https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixTemplate)

