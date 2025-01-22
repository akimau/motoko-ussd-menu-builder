import { menuItemsAreEqual } "../../src/Ussd/modules/Menu";

let tMenuItem1 = {
    id = "menu-item-1";
    text = "Menu item 1";
    options = null;
    next = null;
    exec = null;
};

let tMenuItem2 = { tMenuItem1 with id = "menu-item-1"; text = "Item 2" };
let tMenuItem3 = { tMenuItem1 with id = "menu-item-2" };

assert menuItemsAreEqual(tMenuItem1, tMenuItem2);
assert not menuItemsAreEqual(tMenuItem1, tMenuItem3);
