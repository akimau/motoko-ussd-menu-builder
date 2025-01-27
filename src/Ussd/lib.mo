import Result "mo:base/Result";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Menu "modules/Menu";
import MenuItem "modules/MenuItem";
import MenuOption "modules/MenuOption";
import Session "modules/Session";
import Args "modules/Args";
import Func "modules/Func";
import T "types";

module {
    type Result<Ok, Err> = Result.Result<Ok, Err>;

    public type Menu = Menu.Menu;
    public type MenuItem = MenuItem.MenuItem;
    public type MenuOption = MenuOption.MenuOption;
    public type MenuResult = (Text, Session);
    public type MenuResp = T.MenuResp;
    public type MenuError = T.MenuError;

    public type Run = Func.Run;
    public type NextHandler = Func.NextHandler;
    public type NextHandlerResp = Func.NextHandlerResp;

    public type Args = Args.Args;
    public type Session = Session.Session;

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

    public let { new = newSession; put = saveData; get = readData } = Session;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public func runMenu(menu : Menu, args : Args) : async* MenuResp {
        let result : Result<MenuResult, MenuError> = switch (Menu.getSession(menu, args.sessionId)) {
            case (?session) await* processReply(menu, args, session);
            case (null) await* startSession(menu, args);
        };

        /// process result
        switch (result) {
            case (#ok((text, session))) {
                if (Text.startsWith(text, #text "CON")) {
                    Menu.saveSession(menu, session);
                } else {
                    Menu.deleteSession(menu, session.id);
                };
                #ok(text);
            };
            case (#err(err)) {
                Menu.deleteSession(menu, args.sessionId);
                #err(err);
            };
        };
    };

    func startSession(menu : Menu, args : Args) : async* Result<MenuResult, MenuError> {
        let (id, s) = await* menu.start(args, Session.new(args.sessionId));
        switch (Menu.getMenuItem(menu, id)) {
            case (?menuItem) await* runMenuItem(menuItem, args, s);
            case (null) #err(#MenuNotFound(?id));
        };
    };

    func processReply(menu : Menu, args : Args, session : Session) : async* Result<MenuResult, MenuError> {
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
                                    case (_, ?nextHandler) await* nextHandler(args, session);
                                    case _ return #err(#UnexpectedError);
                                };
                            };
                            case (null) (menuItem.id, session); // wrong input, return same menu id
                        };
                    };
                    // handle free input
                    case (_, ?nextHandler) await* nextHandler(args, session);
                    // unable to process reply. This case should be unreachable
                    case (null, null) return #err(#UnexpectedError);
                };

                if (id == menuItem.id) {
                    // re-run the current menu
                    return await* runMenuItem(menuItem, args, s);
                };

                switch (Menu.getMenuItem(menu, id)) {
                    case (?menuItem) await* runMenuItem(menuItem, args, s);
                    case (null) #err(#MenuNotFound(?id));
                };
            };
            case (null) #err(#MenuNotFound(session.currentMenuItemId));
        };
    };

    func runMenuItem(menuItem : MenuItem, args : Args, session : Session) : async* Result<MenuResult, MenuError> {
        let s = await* menuItem.run(args, session);
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
