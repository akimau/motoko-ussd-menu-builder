import Func "Func";
import T "../types";

module MenuOption {
    type NextHandler = Func.NextHandler;

    public type MenuOption = {
        // The choice input e.g "1"
        choice : T.Choice;

        // The choice text e.g "Terms & Conditions"
        text : T.ChoiceText;

        // The next menu item Id after this option is selected.
        // Has a higher precedence to nextHandler
        next : ?T.NextMenuItemId;

        // The function to execute after this option is selected.
        // Will return the next menu item Id and latest session
        nextHandler : ?NextHandler;
    };

    /// Return a new instance of a MenuOption
    public func new(choice : T.Choice, text : T.ChoiceText, next : ?T.NextMenuItemId, nextHandler : ?NextHandler) : MenuOption {
        { choice; text; next; nextHandler };
    };

    /// Build the displayable menu option text
    public func displayText({ choice; text } : MenuOption) : Text {
        choice # ". " # text; // e.g 1. Terms & Conditions
    };

};
