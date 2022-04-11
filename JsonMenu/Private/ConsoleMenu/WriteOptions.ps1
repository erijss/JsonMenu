function JsonMenu.ConsoleMenu.WriteOptions {
    <#
    .SYNOPSIS
        Writes the options of a menu
    .DESCRIPTION
        The steps are
        - Get the option pattern from the menu's settings of fallback on the default
        - Get the padLeft and PadRight parameters or fallback on the default
        - Loop through the options in the "Options" block from the Json menu and dispaly according the pattern

        A pattern can look like
        {0} : {1}
        {0} | {1}

        The first place is for the option Id
        the second place is for the option value
        The option Id can have a padleft and a padright
    .EXAMPLE
        Options block:
        ==============

        "options": [
            {
                "id": "11",
                "value": "Submenu 2",
                "type": "menu",
                "action": "menu2"
            },
            {
                "id": "b",
                "value": "Exit the menu",
                "type": "exit"
            }
        ],

        Pattern and padLeft
        ===================
        {0} - {1}
        PadLeft = 2
        PadLeft = 0

        Output:
          1 - value of 1
         10 - value of option with id 10
        100 - value of option with id 100
    .INPUTS
        [PSObject]  Options
    .OUTPUTS
        none
    .NOTES
        none
    #>
    param (
        [Parameter()]
        [PSObject]
        $Options
    )

    process {

        # get pattern or default fallback
        $optionPattern = $JsonMenu.Context.Settings.Option.Pattern

        # get padLeft value and convert to integer
        $optionPadLeft = [convert]::ToInt32($JsonMenu.Context.Settings.Option.PadLeft)

        # get padRight value and convert to integer
        $optionPadRight = [convert]::ToInt32($JsonMenu.Context.Settings.Option.PadRight)

        # write options with pattern and padding
        foreach ( $OptionContext in $Options ) {
            $optionValue = $OptionContext.Value | JsonMenu.Functions.Expand
            $option = $($optionPattern -f $OptionContext.Id.PadLeft($optionPadLeft).PadRight($optionPadRight), $optionValue)
            Write-Host  $option
        }
    }
}
