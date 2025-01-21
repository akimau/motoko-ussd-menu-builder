import Map "mo:map/Map";

module Session {
    public type Session = {
        id : Text; // the session id from MenuArgs
        data : Map.Map<Text, Text>; // session's data
        currentMenuItemId : Text; // session's current menu item location
    };

    public func new(id : Text, currentMenuItemId : Text) : Session {
        {
            id;
            data = Map.new();
            currentMenuItemId;
        };
    };
};
