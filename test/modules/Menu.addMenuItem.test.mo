import { addMenuItem; menuItemHash; menuItemsAreEqual } "../../src/Ussd/modules/Menu";
import Set "mo:map/Set";
import MenuItem "../../src/Ussd/modules/MenuItem";
import Menu "../../src/Ussd/modules/Menu";

let tMenu = {
    id = "1";
    description = "description";
    menuItems = Set.new<MenuItem.MenuItem>();
    start = func(_, s) = (null, s);
} : Menu.Menu;

let tMenuItem = {
    id = "menu-item-1";
    run = func(_, s) = s;
    text = "Menu item 1";
    options = null;
    next = null;
    nextHandler = null;
} : MenuItem.MenuItem;

assert Set.empty(tMenu.menuItems);

addMenuItem(tMenu, tMenuItem);

assert Set.size(tMenu.menuItems) == 1;
assert Set.contains(tMenu.menuItems, (menuItemHash, menuItemsAreEqual), tMenuItem) == ?true;
