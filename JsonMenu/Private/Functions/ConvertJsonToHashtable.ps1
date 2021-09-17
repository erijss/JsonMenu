function JsonMenu.Functions.ConvertToHashtable {
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
        $InputObject,
        [Parameter()]
        [Switch]
        $NotRecursive
    )
    process {
        if ( $null -eq $InputObject ) { return $null }

        if ( $false ) {

        }
        elseif ( $InputObject -is [array]) {
            $result =@{}
            for ($i = 0; $i -lt $InputObject.Count; $i++) {
                $result[$i] = (JsonMenu.Functions.ConvertToHashtable -InputObject $InputObject[$i])
            }
            return $result
        }
        elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            foreach ($object in $InputObject) { JsonMenu.Functions.ConvertToHashtable $object }
        }
        elseif ( ($InputObject -is [psobject]) -or ($InputObject -is [pscustomobject]) ) {
            $items = $InputObject | Get-Member -MemberType NoteProperty
            # if ($items) {
                $result = @{}
                foreach( $item in $InputObject.PSObject.Properties ) {
                    $key = $item.Name
                    if( $NotRecursive ) {
                        $value = $InputObject.$key
                    }
                    else {
                        $value = JsonMenu.Functions.ConvertToHashtable -InputObject $InputObject.$key
                    }
                    $result.Add($key, $value)
                }
                return $result
            # } else {
            #     return $InputObject
            # }
        }
        else {
            return $InputObject
        }
    }
}


# process {
#     if ( $null -eq $InputObject ) { return $null }

#     if ( $false ) {

#     }
#     elseif ( $InputObject -is [array]) {
#         $result =@{}
#         for ($i = 0; $i -lt $InputObject.Count; $i++) {
#             $result[$i] = (JsonMenu.Functions.ConvertToHashtable -InputObject $InputObject[$i])
#         }
#         return $result
#     }
#     elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
#     {
#         foreach ($object in $InputObject) { JsonMenu.Functions.ConvertToHashtable $object }
#     }
#     elseif ( ($InputObject -is [psobject]) -or ($InputObject -is [pscustomobject]) ) {
#         $items = $InputObject | Get-Member -MemberType NoteProperty
#         # if ($items) {
#         #     $result = @{}
#             foreach( $item in $InputObject ) {
#                 $key = $item.Name
#                 if( $NotRecursive ) {
#                     $value = $InputObject.$key
#                 }
#                 else {
#                     $value = JsonMenu.Functions.ConvertToHashtable -InputObject $InputObject.$key
#                 }
#                 $result.Add($key, $value)
#             }
#             return $result
#         # } else {
#         #     return $InputObject
#         # }
#     }
#     else {
#         return $InputObject
#     }
# }
