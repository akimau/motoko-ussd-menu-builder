import Debug "mo:base/Debug";

module {

    public class NotificationService() {
        public func sendSms(phone : Text, sms : Text) : async () {
            Debug.print("Sending SMS message '" # sms # "' to phone number '" # phone # "'...");
        };
    };
};
