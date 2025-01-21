import { getStartMenuItem; menuItemHash; menuItemsAreEqual } "../../src/Ussd/modules/Menu";
import Option "mo:base/Option";
import Set "mo:map/Set";
import MenuItem "../../src/Ussd/modules/MenuItem";

let tMenu = {
    id = "1";
    description = "description";
    menuItems = Set.new<MenuItem.MenuItem>();
    startMenuItemId = "menu-item-1";
};

let tMenu2 = {
    tMenu with menuItems = Set.make<MenuItem.MenuItem>(
        (menuItemHash, menuItemsAreEqual),
        {
            id = "menu-item-1";
            text = "Menu item 1";
            options = null;
            next = null;
            exec = null;
        },
    )
};

let menu1Start = getStartMenuItem(tMenu);
let menu2Start = getStartMenuItem(tMenu2);

assert Option.isNull(menu1Start);
assert Option.isSome(menu2Start);
do ? {
    assert menu2Start!.id == "menu-item-1";
};
