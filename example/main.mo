import Result "mo:base/Result";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import { JSON } "mo:serde";

import Http "http";

import UserService "services/UserService";
import NotificationService "services/NotificationService";

import SampleUssdMenu "SampleUssdMenu";

import Ussd "../src/Ussd";
import { runMenu; newArgs } "../src/Ussd";

persistent actor Main {
    type Result<Ok, Err> = Result.Result<Ok, Err>;

    transient let userSvc = UserService.UserService();
    transient let notifSvc = NotificationService.NotificationService();

    transient let ussdMenu = SampleUssdMenu.MenuBuilder(userSvc, notifSvc).build();

    public query func http_request(_ : Http.Request) : async Http.Response {
        Debug.print("Upgrading to update request.\n");
        {
            status_code = 404;
            headers = [];
            body = Blob.fromArray([]);
            streaming_strategy = null;
            upgrade = ?true;
        };
    };

    public func http_request_update(req : Http.Request) : async Http.Response {
        let result = switch (Text.decodeUtf8(req.body)) {
            case (?jsonText) JSON.fromText(jsonText, null);
            case (null) #err "Failed to decode body";
        };

        switch (result) {
            case (#ok(blob)) {
                let args : ?{
                    sessionId : Text;
                    phoneNumber : Text;
                    serviceCode : Text;
                    text : Text;
                } = from_candid (blob);

                switch (args) {
                    case (?args) {
                        Debug.print("Deserialized request body: " # debug_show (args));

                        let { sessionId; phoneNumber; serviceCode; text } = args;

                        switch (
                            newArgs(sessionId, phoneNumber, serviceCode, text)
                            |> (await* runMenu(ussdMenu, _))
                        ) {
                            case (#ok(displayText)) {
                                return {
                                    status_code : Nat16 = 200;
                                    headers = [("content-type", "text/plain")];
                                    body = Text.encodeUtf8(displayText);
                                    streaming_strategy = null;
                                    upgrade = null;
                                };
                            };
                            case (#err(error)) Debug.trap(debug_show error);
                        };
                    };
                    case (null) Debug.trap("Failed to deseriaize request body");
                };
            };
            case (#err(err)) Debug.trap(err);
        };
    };

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
