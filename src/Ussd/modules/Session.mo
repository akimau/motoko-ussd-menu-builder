import Time "mo:base/Time";
import AssocList "mo:base/AssocList";
import Text "mo:base/Text";
import T "../types";

module Session {
    type Time = Time.Time;

    public type Session = {
        id : T.SessionId; // the session id from MenuArgs
        data : T.SessionData; // session's data
        currentMenuItemId : ?T.MenuItemId; // session's current menu item location
        createdAt : Time;
        updatedAt : Time;
    };

    /// Return a new session
    public func new(id : T.SessionId) : Session {
        let now = Time.now();
        {
            id;
            data = null;
            currentMenuItemId = null;
            createdAt = now;
            updatedAt = now;
        };
    };

    /// Update session data
    public func put(s : Session, k : Text, v : Text) : Session {
        let { id; data; currentMenuItemId; createdAt } = s;
        {
            id;
            data = AssocList.replace(data, k, Text.equal, ?v).0;
            currentMenuItemId;
            createdAt;
            updatedAt = Time.now();
        };
    };

    /// Read session data
    public func get(s : Session, k : Text) : ?Text {
        AssocList.find(s.data, k, Text.equal);
    };
};
