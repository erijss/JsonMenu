function JsonMenu.Validation.ValidateConfiguration {

    $jsonMenuContext.Settings = $jsonMenuContext.Constants

    if ( $jsonMenuContext.Configuration.Settings ) {
        # $jsonMenuContext.Settings = $jsonMenuContext.Configuration.Settings
        # for easy access add menus as hashtable with the id as key
        foreach ( $setting in $jsonMenuContext.Configuration.Settings.PSObject.Properties )
        {
            $jsonMenuContext.Settings[$setting.Name] = $setting.Value
        }
    }
    if ( $jsonMenuContext.Configuration.Menus ) {
        # for easy access add menus as hashtable with the id as key
        foreach ( $menu in $jsonMenuContext.Configuration.Menus )
        {
            $jsonMenuContext.Menus[$menu.id] = $menu
        }
    }
    if ( $jsonMenuContext.Configuration.Actions ) {
        # for easy access add actions as hashtable with the id as key
        foreach ( $action in $jsonMenuContext.Configuration.Actions )
        {
            $jsonMenuContext.Actions[$action.id] =$action
        }
    }
    if ( $jsonMenuContext.Configuration.Texts ) {
        # for easy access add texts as hashtable with the id as key
        foreach ( $textt in $jsonMenuContext.Configuration.Texts )
        {
            $jsonMenuContext.Texts[$text.id] = $text
        }
    }
}
