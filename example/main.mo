import Result "mo:base/Result";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import { JSON } "mo:serde";

import Http "http";

import UserService "services/UserService";
import NotificationService "services/NotificationService";

import SampleUssdMenu "SampleUssdMenu";

import { runMenu; newArgs } "../src/Ussd";

persistent actor Main {
    type Result<Ok, Err> = Result.Result<Ok, Err>;

    type UssdReqPayload = {
        sessionId : Text;
        phoneNumber : Text;
        serviceCode : Text;
        text : Text;
    };

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
            case (null) #err "Failed to decode request body";
        };

        switch (result) {
            case (#ok(blob)) {
                switch (from_candid (blob) : ?UssdReqPayload) {
                    case (?{ sessionId; phoneNumber; serviceCode; text }) {
                        let menuResp = newArgs(sessionId, phoneNumber, serviceCode, text)
                        |> (await* runMenu(ussdMenu, _));

                        switch (menuResp) {
                            case (#ok(displayText)) {
                                return {
                                    status_code : Nat16 = 200;
                                    headers = [("content-type", "text/plain")];
                                    body = Text.encodeUtf8(displayText);
                                    streaming_strategy = null;
                                    upgrade = null;
                                };
                            };
                            case (#err(err)) Debug.trap(debug_show err);
                        };
                    };
                    case (null) Debug.trap("Failed to deserialize request payload");
                };
            };
            case (#err(err)) Debug.trap(err);
        };
    };

    public query func info() : async { id : Text; description : Text } {
        { id = ussdMenu.id; description = ussdMenu.description };
    };

};
