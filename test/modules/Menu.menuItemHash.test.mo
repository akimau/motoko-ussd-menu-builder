import { menuItemHash } "../../src/Ussd/modules/Menu";
import Text "mo:base/Text";

let tMenuItem = {
    id = "menu-item-1";
    text = "Menu item 1";
    options = null;
    next = null;
    exec = null;
};

assert menuItemHash(tMenuItem) == Text.hash("menu-item-1");
