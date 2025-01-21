import MenuFunc "MenuFunc";

module MenuOption {
    type MenuFunc = MenuFunc.MenuFunc;

    public type MenuOption = {
        choice : Text; // e.g "1"
        text : Text; // e.g "Terms & Conditions"
        nextMenuItemId : Text; // the next menu item Id after option is selected
        exec : ?MenuFunc; // the function to execute after option is selected
    };

    public func displayText({ choice; text } : MenuOption) : Text {
        choice # ". " # text; // e.g 1. Terms & Conditions
    };
};
