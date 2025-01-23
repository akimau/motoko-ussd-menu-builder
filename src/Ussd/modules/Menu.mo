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

    /// Add a menu item to the menu
    public func addMenuItem({ menuItems } : Menu, item : MenuItem) {
        Set.add(menuItems, (menuItemHash, menuItemsAreEqual), item);
    };

    /// Get menu item with the given id from the menu
    public func getMenuItem({ menuItems } : Menu, menuItemId : T.MenuItemId) : ?MenuItem {
        Set.find<MenuItem>(menuItems, func item = item.id == menuItemId);
    };

    public func menuItemHash(item : MenuItem) : Nat32 = Text.hash(item.id);

    public func menuItemsAreEqual(a : MenuItem, b : MenuItem) : Bool = Text.equal(a.id, b.id);
};
