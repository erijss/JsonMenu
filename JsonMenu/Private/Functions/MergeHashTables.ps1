
function JsonMenu.Functions.MergeHashtable {
    <#
    .SYNOPSIS
        Merge hashtables into a single and apply operators on new combined values of the hashtable
    .DESCRIPTION
        When multiple hashtables are merged all values of the same key are combined into an array. This
        is the default return value of the merged hashtables.

        By using an Operator (ScriptBlock) or a predefined Operation, the values can be manipulated. The
        predefined Operations are
        - First: returns the first element of the merged values
        - Last: returns the last element of the merged values
        - Minimum: returns the minimum value of the merged values (works only with numeric values)
        - Maximum: returns the maximum value of the merged values (works only with numeric values)
        - Sum: returns the sum of all values (works only with numeric values)
        - Average: returns the average of all values (works only with numeric values)
        - Join: returns the concatenat strig of all values

        By using a ScriptBlock as operator value, other manipulations on the value can be invoked.
    .EXAMPLE
        $h1 = @{ a = 1; b = 2; c = 3 }
        $h2 = @{ a = 3; c = 1; d = 4 }

        PS C:\> Merged-HashTable -HashTables @( $h1, $h2 )
        Name        Value
        ----        -----
        c           {3, 1}
        a           {1, 3}
        d           4
        b           2

        PS C:\> $h1, $h2 | Merged-HashTable -Operation "First"
        Name        Value
        ----        -----
        c           3
        a           1
        d           4
        b           2

        PS C:\> $h1, $h2 | Merged-HashTable -Operation "Last"
        Name        Value
        ----        -----
        c           1
        a           3
        d           4
        b           2

        PS C:\> $h1, $h2 | Merged-HashTable -Operation "Sum"
        Name        Value
        ----        -----
        c           4
        a           4
        d           4
        b           2

        PS C:\> $h1, $h2 | Merged-HashTable -Operator { $Value -Join "-" }
        Name    Value
        ----    -----
        c       3-1
        a       1-3
        d       4
        b       2

    .INPUTS
        [Hashtable[]]   Hashtables
        [String]        Operation

        or

        [Hashtable[]]   Hashtables
        [ScriptBlock]   Operator
    .OUTPUTS
        [Hashtable]      MergedHashtable
    .NOTES
        The original idea of this function was found on StackOverflow (https://stackoverflow.com/a/32890418)
        and proposed by iRon (https://stackoverflow.com/users/1701026/iron)
    #>
    [CmdletBinding(DefaultParameterSetName = "Operator")]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "Operator")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "Operation")]
        [Hashtable[]]
        $Hashtables,
        [Parameter(ParameterSetName = "Operator")]
        [ScriptBlock]
        $Operator,
        [Parameter(ParameterSetName = "Operation")]
        [ValidateSet("First", "Last", "Maximum", "Minimum", "Sum", "Average", "Join")]
        [String]
        $Operation
    )

    begin {
        $MergedHashtable = @{}
    }
    process {
        foreach ($Hashtable in ($Hashtables)) {
            if ($Hashtable -is [Hashtable]) {
                foreach ($Key in $Hashtable.Keys) {
                    $MergedHashtable.$Key = if ($MergedHashtable.ContainsKey($Key)) {
                        @($MergedHashtable.$Key) + $Hashtable.$Key
                    }
                    else {
                        $Hashtable.$Key
                    }
                }
            }
        }
    }
    end {
        switch ( $PSCmdlet.ParameterSetName ) {
            "Operation" {
                switch ($Operation) {
                    "First" {
                        [ScriptBlock]$Operator = { $Value[0] }
                        break
                    }
                    "Last" {
                        [ScriptBlock]$Operator = { $Value[-1] }
                        break
                    }
                    "Maximum" {
                        [ScriptBlock]$Operator = { ($Value | Measure-Object -Maximum).Maximum }
                        break
                    }
                    "Minimum" {
                        [ScriptBlock]$Operator = { ($Value | Measure-Object -Minimum).Minimum }
                        break
                    }
                    "Sum" {
                        [ScriptBlock]$Operator = { ($Value | Measure-Object -Sum).Sum }
                        break
                    }
                    "Average" {
                        [ScriptBlock]$Operator = { ($Value | Measure-Object -Average).Average }
                        break
                    }
                    "Join" {
                        [ScriptBlock]$Operator = { $Value -Join "" }
                        break
                    }
                }
                break
            }
            "Operator" {
                break
            }
        }

        if ($Operator) {
            foreach ($Key in @($MergedHashtable.Keys)) {
                $Value = @($MergedHashtable.$Key);
                $MergedHashtable.$Key = Invoke-Command -ScriptBlock $Operator -InputObject $Value
            }
        }

        $MergedHashtable
    }
}