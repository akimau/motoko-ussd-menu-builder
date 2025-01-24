import MenuOption "MenuOption";
import Func "Func";
import Array "mo:base/Array";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Set "mo:map/Set";
import Session "Session";
import T "../types";

module MenuItem {
    type MenuOption = MenuOption.MenuOption;
    type Run = Func.Run;
    type NextHandler = Func.NextHandler;
    type Session = Session.Session;

    public type MenuItem = {
        // The id of the menu item
        id : T.MenuItemId;

        // The function to run when this menu item is visited
        run : Run;

        // The menu text/prompt without reply options
        // which are specified in the optional options set
        text : T.MenuItemText;

        // If options is null, then free input is allowed
        options : ?T.Set<MenuOption>;

        // The function to execute after free input has been provided
        // Will return the next menu item Id and latest session
        nextHandler : ?NextHandler;
    };

    /// Return a new instance of a MenuItem
    public func new(
        id : T.MenuItemId,
        run : Run,
        text : T.MenuItemText,
        next : ?T.NextMenuItemId,
        nextHandler : ?NextHandler,
    ) : MenuItem { { id; run; text; options = null; next; nextHandler } };

    /// Return a new instance of a MenuItem with options
    public func newWithOptions(
        id : T.MenuItemId,
        run : Run,
        text : T.MenuItemText,
        options : [MenuOption],
    ) : MenuItem {
        assert options.size() > 0;

        Array.vals(options)
        |> Set.fromIter(_, (menuOptionHash, menuOptionsAreEqual))
        |> { id; run; text; options = ?_; nextHandler = null };
    };

    /// Check if menu item specifies a navigable next menu item
    public func hasNext({ options; nextHandler } : MenuItem) : Bool {
        Option.isSome(options) or Option.isSome(nextHandler);
    };

    /// Build the displayable menu item text
    public func displayText({ text; options } : MenuItem, _session : Session) : Text {
        let displayText = switch (options) {
            case (?options) {
                Array.foldLeft<MenuOption, Text>(
                    Set.toArray(options),
                    text,
                    func(acc, option) = acc # "\n" # MenuOption.displayText(option),
                );
            };
            case (null) text;
        };
        // TODO: use session to replace place holder values on the display text
        // e.g if display text is Hello {name}, session data must have a key 'name'
        // whose value can be used to replace the {name} placeholder
        displayText;
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
