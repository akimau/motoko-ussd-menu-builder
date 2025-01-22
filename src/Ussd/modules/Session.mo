import Map "mo:map/Map";
import Time "mo:base/Time";
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

    public func new(id : T.SessionId) : Session {
        let now = Time.now();
        {
            id;
            data = Map.new();
            currentMenuItemId = null;
            createdAt = now;
            updatedAt = now;
        };
    };
};
