import { new } "../../src/Ussd/modules/Menu";
import Set "mo:map/Set";

let { id; description; menuItems; startMenuItemId } = new("id", "description", "menu-item-1");

assert id == "id";
assert description == "description";
assert Set.empty(menuItems);
assert startMenuItemId == "menu-item-1";
