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

    public func wrongPin() {
        Debug.print("############### Starting session ###############");

        var args = newArgs("session-1234", "0722000000", "*690#", "");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 1234...");
        args := newArgs("session-1234", "0722000000", "*690#", "1234");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print(debug_show ({ sessions = ussdMenu.sessions }));
    };

    public func resetPin() {
        Debug.print("############### Starting session ###############");

        var args = newArgs("session-1234", "0722000000", "*690#", "");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 0...");
        args := newArgs("session-1234", "0722000000", "*690#", "0");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 1...");
        args := newArgs("session-1234", "0722000000", "*690#", "0*1");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print(debug_show ({ sessions = ussdMenu.sessions }));
    };

    public func contactUs() {
        Debug.print("############### Starting session ###############");

        var args = newArgs("session-1234", "0722000000", "*690#", "");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 0...");
        args := newArgs("session-1234", "0722000000", "*690#", "0");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 2...");
        args := newArgs("session-1234", "0722000000", "*690#", "0*2");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print(debug_show ({ sessions = ussdMenu.sessions }));
    };

    public func accountBalance() {
        Debug.print("############### Starting session ###############");

        var args = newArgs("session-1234", "0722000000", "*690#", "");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 0000...");
        args := newArgs("session-1234", "0722000000", "*690#", "0000");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 1...");
        args := newArgs("session-1234", "0722000000", "*690#", "0000*1");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print("Replying 00...");
        args := newArgs("session-1234", "0722000000", "*690#", "0000*1*00");
        (await* runMenu(ussdMenu, args)) |> processResponse(_);

        Debug.print(debug_show ({ sessions = ussdMenu.sessions }));
    };

    func processResponse(r : Ussd.MenuResp) {
        switch (r) {
            case (#ok(displayText)) {
                Debug.print(displayText);
            };
            case (#err(error)) {
                Debug.print(debug_show (error));
            };
        };
    };
};
