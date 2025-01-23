import Menu "modules/Menu";
import MenuItem "modules/MenuItem";
import MenuOption "modules/MenuOption";
import Session "modules/Session";
import Args "modules/Args";
import Result "mo:base/Result";
import Time "mo:base/Time";
import T "types";

module {
    type Result<Ok, Err> = Result.Result<Ok, Err>;

    public type Menu = Menu.Menu;
    public type MenuItem = MenuItem.MenuItem;
    public type MenuOption = MenuOption.MenuOption;
    public type Args = Args.Args;
    public type Session = Session.Session;
    public type MenuResp = (Text, Session);

    public type MenuError = {
        #MenuNotFound : ?T.MenuItemId;
        #UnexpectedError;
    };

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newMenu } = Menu;

    public let { addMenuItem } = Menu;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newMenuItem; newWithOptions = newMenuItemWithOptions } = MenuItem;

    public let { getMenuOption } = MenuItem;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newMenuOption } = MenuOption;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newArgs } = Args;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public let { new = newSession } = Session;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public func run(menu : Menu, args : Args, session : ?Session) : Result<MenuResp, MenuError> {
        switch (session) {
            case (?session) processReply(menu, args, session);
            case (null) startSession(menu, args);
        };
    };

    func startSession(menu : Menu, args : Args) : Result<MenuResp, MenuError> {
        let (id, s) = menu.start(args, Session.new(args.sessionId));
        switch (Menu.getMenuItem(menu, id)) {
            case (?menuItem) runMenuItem(menuItem, args, s);
            case (null) #err(#MenuNotFound(?id));
        };
    };

    func processReply(menu : Menu, args : Args, session : Session) : Result<MenuResp, MenuError> {
        // get the current menu item
        let menuItem : ?MenuItem = do ? {
            Menu.getMenuItem(menu, session.currentMenuItemId!)!;
        };

        switch (menuItem) {
            case (?menuItem) {
                // Determine next menu to return
                let (id, s) = switch (menuItem.options, menuItem.nextHandler) {
                    // if there are menu options, handle choice reply
                    case (?_, _) {
                        switch (MenuItem.getMenuOption(menuItem, args.replyText)) {
                            case (?menuOption) {
                                switch (menuOption.next, menuOption.nextHandler) {
                                    case (?next, _) (next, session);
                                    case (_, ?nextHandler) nextHandler(args, session);
                                    case _ return #err(#UnexpectedError);
                                };
                            };
                            case (null) (menuItem.id, session); // wrong input, return same menu id
                        };
                    };
                    // handle free input
                    case (_, ?nextHandler) nextHandler(args, session);
                    // unable to process reply. This case should be unreachable
                    case (null, null) return #err(#UnexpectedError);
                };

                if (id == menuItem.id) {
                    // re-run the current menu
                    return runMenuItem(menuItem, args, s);
                };

                switch (Menu.getMenuItem(menu, id)) {
                    case (?menuItem) runMenuItem(menuItem, args, s);
                    case (null) #err(#MenuNotFound(?id));
                };
            };
            case (null) #err(#MenuNotFound(session.currentMenuItemId));
        };
    };

    func runMenuItem(menuItem : MenuItem, args : Args, session : Session) : Result<MenuResp, MenuError> {
        let s = menuItem.run(args, session);
        let displayText = MenuItem.displayText(menuItem, s);
        #ok(
            (if (MenuItem.hasNext(menuItem)) "CON " else "END ") # displayText,
            {
                s with currentMenuItemId = ?menuItem.id;
                updatedAt = Time.now();
            },
        );
    };

};
