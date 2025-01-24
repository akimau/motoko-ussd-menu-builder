import { new } "../../src/Ussd/modules/Session";
import Time "mo:base/Time";
import Option "mo:base/Option";
import List "mo:base/List";

let now = Time.now();

let { id; data; currentMenuItemId; createdAt; updatedAt } = new("sessionid");

assert id == "sessionid";
assert List.isNil(data);
assert Option.isNull(currentMenuItemId);
assert createdAt == now;
assert updatedAt == now;
