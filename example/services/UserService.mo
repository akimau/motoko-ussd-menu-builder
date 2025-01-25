module {
    public class UserService() {
        public func authenticateUser(phone : Text, pin : Text) : Bool {
            if (phone == "0722000000" and pin == "0000") return true;
            false;
        };

        public func getUserName(phone : Text) : Text {
            if (phone == "0722000000") return "John Doe";
            "";
        };

        public func getAccountBalance(phone : Text) : (Float, Float) {
            if (phone == "0722000000") return (100_000, 85_000);
            (0, 0);
        };
    };
};
