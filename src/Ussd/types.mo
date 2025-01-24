import Set "mo:map/Set";
import AssocList "mo:base/AssocList";

module {
    public type Set<T> = Set.Set<T>;

    public type MenuId = Text;
    public type MenuDescription = Text;
    public type MenuItemId = Text;
    public type NextMenuItemId = MenuItemId;
    public type MenuItemText = Text;
    public type Choice = Text;
    public type ChoiceText = Text;

    public type SessionId = Text;
    public type SessionData = AssocList.AssocList<Text, Text>;

    public type PhoneNumber = Text;
    public type ServiceCode = Text;
};
