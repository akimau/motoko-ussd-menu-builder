import Text "mo:base/Text";
import Iter "mo:base/Iter";
import List "mo:base/List";
import T "../types";

/// USSD Args
module Args {
    public type Args = {
        sessionId : T.SessionId;
        phoneNumber : T.PhoneNumber;
        serviceCode : T.ServiceCode;
        text : Text;
        replyText : Text;
    };

    public func new(
        sessionId : T.SessionId,
        phoneNumber : T.PhoneNumber,
        serviceCode : T.ServiceCode,
        text : Text,
    ) : Args {
        let replyText = switch (getReplyText(text)) {
            case (?reply) reply;
            case (null) "";
        };
        { sessionId; phoneNumber; serviceCode; text; replyText };
    };

    public func getReplyText(text : Text) : ?Text {
        // ussd text are usually of the format 100*john doe*10*Kenyan etc
        // the reply text is the last text after the last * character
        Text.trim(text, #char ' ')
        |> Text.split(_, #char '*')
        |> Iter.toList(_)
        |> List.last(_);
    };
};
