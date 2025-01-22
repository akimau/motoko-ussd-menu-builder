import { addMenuItem; menuItemHash; menuItemsAreEqual } "../../src/Ussd/modules/Menu";
import Set "mo:map/Set";
import MenuItem "../../src/Ussd/modules/MenuItem";

let tMenu = {
    id = "1";
    description = "description";
    menuItems = Set.new<MenuItem.MenuItem>();
    startMenuItemId = "menu-item-1";
};

let tMenuItem = {
    id = "menu-item-1";
    text = "Menu item 1";
    options = null;
    next = null;
    exec = null;
};

assert Set.empty(tMenu.menuItems);

addMenuItem(tMenu, tMenuItem);

assert Set.size(tMenu.menuItems) == 1;
assert Set.contains(tMenu.menuItems, (menuItemHash, menuItemsAreEqual), tMenuItem) == ?true;
