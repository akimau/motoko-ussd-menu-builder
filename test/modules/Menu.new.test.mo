import { new } "../../src/Ussd/modules/Menu";
import Set "mo:map/Set";

let { id; description; menuItems } = new("id", "description", func(_, s) = (null, s));

assert id == "id";
assert description == "description";
assert Set.empty(menuItems);
