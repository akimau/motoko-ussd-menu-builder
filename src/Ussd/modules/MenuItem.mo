import MenuOption "MenuOption";
import MenuFunc "MenuFunc";
import Array "mo:base/Array";

module MenuItem {
    type MenuOption = MenuOption.MenuOption;
    type MenuFunc = MenuFunc.MenuFunc;

    public type MenuItem = {
        id : Text;
        text : Text;
        options : ?[MenuOption]; // if options is null, then free input is allowed
        nextMenuItemId : ?Text; // the next menu item Id after free input has been provided
        exec : ?MenuFunc; // the function to execute after free input has been provided
    };

    public func endSession({ options; nextMenuItemId } : MenuItem) : Bool {
        switch (options) {
            case (?options) { options.size() == 0 and nextMenuItemId == null };
            case (null) nextMenuItemId == null;
        };
    };

    public func displayText({ text; options } : MenuItem) : Text {
        switch (options) {
            case (?options) {
                Array.foldLeft<MenuOption, Text>(
                    options,
                    text,
                    func(acc, option) = acc # "\n" # MenuOption.displayText(option),
                );
            };
            case (null) text;
        };
    };

};
