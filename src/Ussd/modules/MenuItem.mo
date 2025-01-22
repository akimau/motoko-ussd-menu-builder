import MenuOption "MenuOption";
import Func "Func";
import Array "mo:base/Array";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Set "mo:map/Set";
import T "../types";

module MenuItem {
    type MenuOption = MenuOption.MenuOption;
    type Func = Func.Func;

    public type MenuItem = {
        id : T.MenuItemId;
        text : T.MenuItemText;
        options : ?T.Set<MenuOption>; // if options is empty, then free input is allowed
        next : ?T.NextMenuItemId; // the next menu item Id after free input has been provided
        exec : ?Func; // the function to execute after free input has been provided
    };

    /// Return a new instance of a MenuItem
    public func new(
        id : T.MenuItemId,
        text : T.MenuItemText,
        next : ?T.NextMenuItemId,
        exec : ?Func,
    ) : MenuItem { { id; text; options = null; next; exec } };

    /// Return a new instance of a MenuItem with options
    public func newWithOptions(
        id : T.MenuItemId,
        text : T.MenuItemText,
        options : [MenuOption],
    ) : MenuItem {
        assert options.size() > 0;

        Array.vals(options)
        |> Set.fromIter(_, (menuOptionHash, menuOptionsAreEqual))
        |> { id; text; options = ?_; next = null; exec = null };
    };

    /// Check if menu item specifies a navigable next menu item
    public func hasNext({ options; next } : MenuItem) : Bool {
        Option.isSome(options) or Option.isSome(next);
    };

    /// Build the displayable menu item text
    public func displayText({ text; options } : MenuItem) : Text {
        switch (options) {
            case (?options) {
                Array.foldLeft<MenuOption, Text>(
                    Set.toArray(options),
                    text,
                    func(acc, option) = acc # "\n" # MenuOption.displayText(option),
                );
            };
            case (null) text;
        };
    };

    /// Get the menu option with the given choice
    public func getMenuOption({ options } : MenuItem, choice : T.Choice) : ?MenuOption {
        switch (options) {
            case (?opts) Set.find<MenuOption>(opts, func opt = opt.choice == choice);
            case (null) null;
        };
    };

    public func menuOptionHash(option : MenuOption) : Nat32 = Text.hash(option.choice);

    public func menuOptionsAreEqual(a : MenuOption, b : MenuOption) : Bool = Text.equal(a.choice, b.choice);

};
