import { new } "../../src/Ussd/modules/Menu";
import Set "mo:map/Set";
import Args "../../src/Ussd/modules/Args";
import Session "../../src/Ussd/modules/Session";
import Func "../../src/Ussd/modules/Func";

let start = func(_ : Args.Args, s : Session.Session) : async* Func.NextHandlerResp = async* ("", s);

let { id; description; menuItems } = new("id", "description", start);

assert id == "id";
assert description == "description";
assert Set.empty(menuItems);
