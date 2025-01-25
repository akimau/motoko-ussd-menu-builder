import Text "mo:base/Text";
import Set "mo:map/Set";
import Map "mo:map/Map";
import { thash } "mo:map/Map";
import Func "Func";
import MenuItem "MenuItem";
import Session "Session";
import T "../types";

module Menu {
    type MenuItem = MenuItem.MenuItem;
    type NextHandler = Func.NextHandler;
    type Session = Session.Session;

    public type Menu = {
        id : T.MenuId;
        description : T.MenuDescription;
        menuItems : Set.Set<MenuItem>;
        sessions : Map.Map<T.SessionId, Session>;
        start : NextHandler;
    };

    /// Return an instance of ussd menu
    public func new(
        id : T.MenuId,
        description : T.MenuDescription,
        start : NextHandler,
    ) : Menu = {
        id;
        description;
        menuItems = Set.new();
        sessions = Map.new();
        start;
    };

    /// save session with the given id
    public func saveSession({ sessions } : Menu, session : Session) {
        Map.set(sessions, thash, session.id, session);
    };

    /// Get session with the given id
    public func getSession({ sessions } : Menu, sessionId : T.SessionId) : ?Session {
        Map.get(sessions, thash, sessionId);
    };

    /// Delete session with the given id
    public func deleteSession({ sessions } : Menu, sessionId : T.SessionId) {
        Map.delete(sessions, thash, sessionId);
    };

    /// Add a menu item to the menu
    public func addMenuItem({ menuItems } : Menu, item : MenuItem) {
        Set.add(menuItems, (menuItemHash, menuItemsAreEqual), item);
    };

    /// Get menu item with the given id from the menu
    public func getMenuItem({ menuItems } : Menu, menuItemId : T.MenuItemId) : ?MenuItem {
        Set.find<MenuItem>(menuItems, func item = item.id == menuItemId);
    };

    public func menuItemHash(item : MenuItem) : Nat32 = Text.hash(item.id);

    public func menuItemsAreEqual(a : MenuItem, b : MenuItem) : Bool = Text.equal(a.id, b.id);
};
