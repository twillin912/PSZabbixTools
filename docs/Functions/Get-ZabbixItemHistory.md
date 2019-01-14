---
external help file: ZabbixTools-help.xml
Module Name: ZabbixTools
online version: https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItemHistory
schema: 2.0.0
---

# Get-ZabbixItemHistory

## SYNOPSIS
Gets the item history from a Zabbix server.

## SYNTAX

```
Get-ZabbixItemHistory [[-ItemId] <Int32[]>] [[-ValueType] <Int32>] [[-Last] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ZabbixItemHistory cmdlet gets the item history from a Zabbix server.

Without parameters, this cmdlet gets all items on the server. 
You can also specify a particular item\[s\] by item id, host id, item name, or item key.

## EXAMPLES

### EXAMPLE 1
```
Get-ZabbixItemHistory
```

Get all items on the server.

### EXAMPLE 2
```
Get-ZabbixItemHistory -ItemId 100
```

Get item data for an item with item id 100

### EXAMPLE 3
```
Get-ZabbixItemHistory -Name MyServer | Get-ZabbixItem
```

Get item data for all items on the host 'MyServer'

### EXAMPLE 4
```
Get-ZabbixItemHistory -Name "Free Space*"
```

Get item data where the name value matches the input string

### EXAMPLE 5
```
Get-ZabbixItemHistory -Key "vfs.fs.size*"
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

### -ValueType
{{Fill ValueType Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: value_type

Required: False
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Last
Indicates the number of values to return for each item. 
By default only the most recent value is returned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1
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

[https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItemHistory](https://poshzabbixtools.readthedocs.io/en/latest/en-US/Get-ZabbixItemHistory)

