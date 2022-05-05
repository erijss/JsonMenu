---
external help file: JsonMenu-help.xml
Module Name: JsonMenu
online version:
schema: 2.0.0
---

# Invoke-JsonMenu

## SYNOPSIS
Invoke the Json menu definition to run a menu in the console or as a system tray menu

## SYNTAX

### Object (Default)
```
Invoke-JsonMenu [-Object] <PSObject> [-AsSysTrayMenu] [<CommonParameters>]
```

### Path
```
Invoke-JsonMenu [-Path] <String> [-AsSysTrayMenu] [<CommonParameters>]
```

### Json
```
Invoke-JsonMenu [-Json] <String> [-AsSysTrayMenu] [<CommonParameters>]
```

## DESCRIPTION
Invoke-Menu creates a menu based on structured Json format.
The Json contains definitions for menu optinos

## EXAMPLES

### EXAMPLE 1
```
<example usage>
```

Explanation of what the example does

## PARAMETERS

### -Object
A converted JsonMenu json definition

```yaml
Type: PSObject
Parameter Sets: Object
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Path
Specifies a path to one or more locations.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Json
Specifies a path to one or more locations.

```yaml
Type: String
Parameter Sets: Json
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsSysTrayMenu
Specifies if the function is only validating the input.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Input (if any)
## OUTPUTS

### Output (if any)
## NOTES
General notes

## RELATED LINKS
