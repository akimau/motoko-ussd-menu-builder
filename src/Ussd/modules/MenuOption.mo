import Func "Func";
import T "../types";

module MenuOption {
    type Func = Func.Func;

    public type MenuOption = {
        choice : T.Choice; // The choice input e.g "1"
        text : T.ChoiceText; // The choice text e.g "Terms & Conditions"
        next : T.NextMenuItemId; // The next menu item Id after this option is selected
        exec : ?Func; // The function to execute after this option is selected
    };

    /// Return a new instance of a MenuOption
    public func new(choice : T.Choice, text : T.ChoiceText, next : T.NextMenuItemId, exec : ?Func) : MenuOption {
        { choice; text; next; exec };
    };

    /// Build the displayable menu option text
    public func displayText({ choice; text } : MenuOption) : Text {
        choice # ". " # text; // e.g 1. Terms & Conditions
    };

};
