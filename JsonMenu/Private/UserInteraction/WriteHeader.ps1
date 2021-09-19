function JsonMenu.UserInteraction.WriteHeader {
    <#
    .SYNOPSIS
        Writes header block from json menu
    .DESCRIPTION
        The steps are:
        - check is a linebreak shouuld be added
        - loop throug the lines of the header
        - if a line starts and ends with curly brackets
          evaluate it as scriptblock
        - Otherwise replace context variables and write output
        - check if a linebreak should added at the end
    .EXAMPLE
        "header": [
            "this is a line",
            "and this is a line to",
            "{ Write-Ouput 'And this is a scriptblock' }"
        ]
    .INPUTS
        [PSCustomObject]    Header
        [Bool]              AddLineBreakBefore
        [Bool]              AddLineBreakafter
    .OUTPUTS
        none
    .NOTES
        The Boolean type of the linebreaks are on purpose because
        they're set in code.
    #>
    param (
        [Parameter()]
        [String[]]
        $Header,
        [Parameter()]
        [Bool]
        $AddLineBreakBefore = $false,
        [Parameter()]
        [Bool]
        $AddLineBreakAfter = $false
    )

    process {
        if ( $Header ) {
            if ( $AddLineBreakBefore ) {
                Write-Host " "
            }

            # $Header = $Header | JsonMenu.Functions.Expand
            foreach ($line in $Header) {
                $line = $line | JsonMenu.Functions.Expand
                Write-Host $line
            }

            if ( $AddLineBreakAfter ) {
                Write-Host " "
            }
        }
    }
}
