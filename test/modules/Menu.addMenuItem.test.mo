import { addMenuItem; menuItemHash; menuItemsAreEqual } "../../src/Ussd/modules/Menu";
import Set "mo:map/Set";
import MenuItem "../../src/Ussd/modules/MenuItem";
import Menu "../../src/Ussd/modules/Menu";
import Args "../../src/Ussd/modules/Args";
import Session "../../src/Ussd/modules/Session";
import Func "../../src/Ussd/modules/Func";

let start = func(_ : Args.Args, s : Session.Session) : async* Func.NextHandlerResp = async* ("", s);
let run = func(_ : Args.Args, s : Session.Session) : async* Session.Session = async* s;

let tMenu = {
    id = "1";
    description = "description";
    menuItems = Set.new<MenuItem.MenuItem>();
    start;
} : Menu.Menu;

let tMenuItem = {
    id = "menu-item-1";
    run;
    text = "Menu item 1";
    options = null;
    next = null;
    nextHandler = null;
} : MenuItem.MenuItem;

assert Set.empty(tMenu.menuItems);

addMenuItem(tMenu, tMenuItem);

assert Set.size(tMenu.menuItems) == 1;
assert Set.contains(tMenu.menuItems, (menuItemHash, menuItemsAreEqual), tMenuItem) == ?true;
