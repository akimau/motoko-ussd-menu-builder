import { menuItemHash } "../../src/Ussd/modules/Menu";
import Text "mo:base/Text";
import MenuItem "../../src/Ussd/modules/MenuItem";

let tMenuItem = {
    id = "menu-item-1";
    run = func(_, s) = s;
    text = "Menu item 1";
    options = null;
    next = null;
    nextHandler = null;
} : MenuItem.MenuItem;

assert menuItemHash(tMenuItem) == Text.hash("menu-item-1");
