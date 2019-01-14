---
external help file: ZabbixTools-help.xml
Module Name: ZabbixTools
online version: https://pszabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItem
schema: 2.0.0
---

# Get-ZabbixItem

## SYNOPSIS
Gets the items from a Zabbix server.

## SYNTAX

```
Get-ZabbixItem [[-ItemId] <Int32[]>] [[-HostId] <Int32[]>] [[-Name] <String>] [[-Key] <String>] [-Short]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-ZabbixItem cmdlet gets the items from a Zabbix server.

Without parameters, this cmdlet gets all items on the server. 
You can also specify a particular item\[s\] by item id, host id, item name, or item key.

## EXAMPLES

### EXAMPLE 1
```
Get-ZabbixItem
```

Get all items on the server.

### EXAMPLE 2
```
Get-ZabbixItem -ItemId 100,101
```

Get data for items with id 100 or 101

### EXAMPLE 3
```
Get-ZabbixHost -Name MyServer | Get-ZabbixItem
```

Get item data for all items on the host 'MyServer'

### EXAMPLE 4
```
Get-ZabbixItem -Name "Free Space*"
```

Get item data where the name value matches the input string

### EXAMPLE 5
```
Get-ZabbixItem -Key "vfs.fs.size*"
```

Get item data where the key value matches the input string

## PARAMETERS

### -ItemId
Specifies one or more items by item id.
You can type multiple item ids (separated by commas).

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

### -HostId
Specifies one or more items by host id.
You can type multiple host ids (separated by commas).

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
Specifies one or more items by item name. 
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

### -Key
Specifies one or more items by item key. 
You can use wildcard characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Short
Indicates that only the ItemId and ValueType values are returned. 
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

### Custom.Zabbix.Item
## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://pszabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItem](https://pszabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItem)

