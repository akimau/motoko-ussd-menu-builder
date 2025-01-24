import Result "mo:base/Result";
import Debug "mo:base/Debug";

import UserService "services/UserService";
import NotificationService "services/NotificationService";

import SampleUssdMenu "SampleUssdMenu";

import Ussd "../src/Ussd";
import { run = runMenu; newArgs } "../src/Ussd";

persistent actor Main {
    type Result<Ok, Err> = Result.Result<Ok, Err>;

    transient let userSvc = UserService.UserService();
    transient let notifSvc = NotificationService.NotificationService();

    transient let ussdMenu = SampleUssdMenu.MenuBuilder(userSvc, notifSvc).build();

    public query func info() : async { id : Text; description : Text } {
        { id = ussdMenu.id; description = ussdMenu.description };
    };

    public func run() {
        var args = newArgs("session-1234", "0722000000", "*690#", "");
        var result = await* runMenu(ussdMenu, args, null);
        var session = processResult(result);

        args := newArgs("session-1234", "0722000000", "*690#", "0");
        result := await* runMenu(ussdMenu, args, session);
        session := processResult(result); // should print forgot pin menu

        args := newArgs("session-1234", "0722000000", "*690#", "0*1");
        result := await* runMenu(ussdMenu, args, session);
        session := processResult(result); // should print reset pin menu
    };

    public func run2() {
        var args = newArgs("session-1234", "0722000000", "*690#", "");
        var result = await* runMenu(ussdMenu, args, null);
        var session = processResult(result);

        args := newArgs("session-1234", "0722000000", "*690#", "0000");
        result := await* runMenu(ussdMenu, args, session);
        session := processResult(result); // should print main menu

        args := newArgs("session-1234", "0722000000", "*690#", "0000*1");
        result := await* runMenu(ussdMenu, args, session);
        session := processResult(result); // should print account balance

        args := newArgs("session-1234", "0722000000", "*690#", "0000*1*00");
        result := await* runMenu(ussdMenu, args, session);
        session := processResult(result); // should print bye menu
    };

    func processResult(r : Result<Ussd.MenuResp, Ussd.MenuError>) : ?Ussd.Session {
        switch (r) {
            case (#ok(displayText, session)) {
                Debug.print(debug_show ({ displayText; session }));
                ?session;
            };
            case (#err(error)) {
                Debug.print(debug_show (error));
                null;
            };
        };
    };
};
