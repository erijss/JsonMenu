function JsonMenu.Validation.ValidateConfiguration {

    $JsonMenu.Context.Settings = $JsonMenu.Constants

    if ( $JsonMenu.Configuration.Settings ) {
        # $JsonMenu.Context.Settings = $JsonMenu.Configuration.Settings
        # for easy access add menus as hashtable with the id as key
        foreach ( $setting in $JsonMenu.Configuration.Settings.PSObject.Properties )
        {
            $JsonMenu.Context.Settings[$setting.Name] = $setting.Value
        }
    }
    if ( $JsonMenu.Configuration.Menus ) {
        # for easy access add menus as hashtable with the id as key
        foreach ( $menu in $JsonMenu.Configuration.Menus )
        {
            $JsonMenu.Context.Menus[$menu.id] = $menu
        }
    }
    if ( $JsonMenu.Configuration.Actions ) {
        # for easy access add actions as hashtable with the id as key
        foreach ( $action in $JsonMenu.Configuration.Actions )
        {
            $JsonMenu.Context.Actions[$action.id] =$action
        }
    }
    if ( $JsonMenu.Configuration.Texts ) {
        # for easy access add texts as hashtable with the id as key
        foreach ( $textt in $JsonMenu.Configuration.Texts )
        {
            $JsonMenu.Context.Texts[$text.id] = $text
        }
    }
}
