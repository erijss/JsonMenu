function JsonMenu.Functions.ConvertToHashtableOld {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $hashTable = @{}
    }

    process {
        foreach ( $item in $InputObject ) {
            $hashTable.Add($item.Id, $item)
        }
    }

    end {
        $hashTable
    }
}
