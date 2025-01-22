import MenuItem "MenuItem";
import Set "mo:map/Set";
import Text "mo:base/Text";
import T "../types";

module Menu {
    type MenuItem = MenuItem.MenuItem;

    public type Menu = {
        id : T.MenuId;
        description : T.MenuDescription;
        menuItems : Set.Set<MenuItem>;
        startMenuItemId : T.MenuItemId; // the id of the start menu item
    };

    /// Return an instance of ussd menu
    public func new(
        id : T.MenuId,
        description : T.MenuDescription,
        startMenuItemId : T.MenuItemId,
    ) : Menu = { id; description; menuItems = Set.new(); startMenuItemId };

    /// Get the start menu item
    public func getStartMenuItem({ startMenuItemId; menuItems } : Menu) : ?MenuItem {
        Set.find<MenuItem>(menuItems, func item = item.id == startMenuItemId);
    };

    /// Add a menu item
    public func addMenuItem({ menuItems } : Menu, item : MenuItem) {
        Set.add(menuItems, (menuItemHash, menuItemsAreEqual), item);
    };

    public func menuItemHash(item : MenuItem) : Nat32 = Text.hash(item.id);

    public func menuItemsAreEqual(a : MenuItem, b : MenuItem) : Bool = Text.equal(a.id, b.id);
};
