import MenuItem "MenuItem";
import Set "mo:map/Set";
import Text "mo:base/Text";
import T "../types";
import Func "Func";

module Menu {
    type MenuItem = MenuItem.MenuItem;
    type NextHandler = Func.NextHandler;

    public type Menu = {
        id : T.MenuId;
        description : T.MenuDescription;
        menuItems : Set.Set<MenuItem>;
        start : NextHandler;
    };

    /// Return an instance of ussd menu
    public func new(
        id : T.MenuId,
        description : T.MenuDescription,
        start : NextHandler,
    ) : Menu = { id; description; menuItems = Set.new(); start };

    /// Add a menu item
    public func addMenuItem({ menuItems } : Menu, item : MenuItem) {
        Set.add(menuItems, (menuItemHash, menuItemsAreEqual), item);
    };

    public func menuItemHash(item : MenuItem) : Nat32 = Text.hash(item.id);

    public func menuItemsAreEqual(a : MenuItem, b : MenuItem) : Bool = Text.equal(a.id, b.id);
};
