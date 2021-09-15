function JsonMenu.Validation.ValidateConfiguration {
    if ( $jsonMenuContext.Configuration.Settings ) {
        $jsonMenuContext.Settings = $jsonMenuContext.Configuration.Settings #| JsonMenu.Functions.ConvertToHashtable
    }
    if ( $jsonMenuContext.Configuration.Menus ) {
        $jsonMenuContext.Menus = $jsonMenuContext.Configuration.Menus | JsonMenu.Functions.ConvertToHashtable
    }
    if ( $jsonMenuContext.Configuration.Actions ) {
        $jsonMenuContext.Actions = $jsonMenuContext.Configuration.Actions | JsonMenu.Functions.ConvertToHashtable
    }
}