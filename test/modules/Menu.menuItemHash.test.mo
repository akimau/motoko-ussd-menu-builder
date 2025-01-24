import { menuItemHash } "../../src/Ussd/modules/Menu";
import Text "mo:base/Text";
import MenuItem "../../src/Ussd/modules/MenuItem";
import Args "../../src/Ussd/modules/Args";
import Session "../../src/Ussd/modules/Session";

let run = func(_ : Args.Args, s : Session.Session) : async* Session.Session = async* s;

let tMenuItem = {
    id = "menu-item-1";
    run;
    text = "Menu item 1";
    options = null;
    next = null;
    nextHandler = null;
} : MenuItem.MenuItem;

assert menuItemHash(tMenuItem) == Text.hash("menu-item-1");
