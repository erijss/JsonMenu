function JsonMenu.Functions.ConvertPSObjectToHashtable {
    <#
    .SYNOPSIS
        Converts a PSCustomObject into a hashtable
    .DESCRIPTION
        A recursive function that converts a PSCustomObject
        into an hashtable. Once the InputObject is not an enumerable anymore
        and is of type PSObject, all the properties are turned into a hashtable
    .EXAMPLE
        none
    .INPUTS
        [PSCustomObject]    $InputObject
    .OUTPUTS
        [Hashtable]
    .NOTES
        The origin of this function was found in multiple blogposts which and
        github repos. They seemed to be exact copies of eachother so I have no clue
        who the original author of this script is. Credits to her/him/them

        Before PowerShell 6, a Json could not be converted directly into a hashtable.
        Therefor this script is purposeful.
    #>
    # param (
    #     [Parameter(ValueFromPipeline)]
    #     [PSCustomObject]
    #     $InputObject
    # )
    param(
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $InputObject,
        [Parameter()]
        [Switch]
        $NotRecursive
    )
    # process {
    #     if ( $null -eq $InputObject ) { return $null }

    #     if ( $InputObject -is [psobject] ) {
    #         $result = @{}
    #         $items = $InputObject | Get-Member -MemberType NoteProperty
    #         foreach( $item in $items ) {
    #             $key = $item.Name
    #             if( $NotRecursive ) {
    #                 $value = $InputObject.$key
    #             }
    #             else {
    #                 $value = JsonMenu.Functions.ConvertPSObjectToHashtable -InputObject $InputObject.$key
    #             }
    #             $result.Add($key, $value)
    #         }
    #         return $result
    #     } elseif ( $InputObject -is [array]) {
    #         $result = $null
    #         for ($i = 0; $i -lt $InputObject.Count; $i++) {
    #             $result[$i] = (JsonMenu.Functions.ConvertPSObjectToHashtable -InputObject $InputObject[$i])
    #         }
    #         return $result
    #     } else {
    #         return $InputObject
    #     }
    # }
    process
    {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            foreach ($object in $InputObject) { JsonMenu.Functions.ConvertPSObjectToHashtable $object }
        }
        elseif ($InputObject -is [psobject])
        {
            $hash = @{}

            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.Name] = JsonMenu.Functions.ConvertPSObjectToHashtable $property.Value
            }

            $hash
        }
        else
        {
            $InputObject
        }
    }
}
