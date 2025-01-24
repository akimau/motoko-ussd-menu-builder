import { menuItemsAreEqual } "../../src/Ussd/modules/Menu";
import MenuItem "../../src/Ussd/modules/MenuItem";
import Args "../../src/Ussd/modules/Args";
import Session "../../src/Ussd/modules/Session";

let run = func(_ : Args.Args, s : Session.Session) : async* Session.Session = async* s;

let tMenuItem1 = {
    id = "menu-item-1";
    run;
    text = "Menu item 1";
    options = null;
    next = null;
    nextHandler = null;
} : MenuItem.MenuItem;

let tMenuItem2 = { tMenuItem1 with id = "menu-item-1"; text = "Item 2" };
let tMenuItem3 = { tMenuItem1 with id = "menu-item-2" };

assert menuItemsAreEqual(tMenuItem1, tMenuItem2);
assert not menuItemsAreEqual(tMenuItem1, tMenuItem3);
