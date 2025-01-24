import Float "mo:base/Float";

import UserService "services/UserService";
import NotificationService "services/NotificationService";

import Ussd "../src/Ussd";
import {
    newMenu;
    newMenuItem;
    newMenuItemWithOptions;
    newMenuOption;
    addMenuItem;
    saveData;
} "../src/Ussd";

module {
    type Menu = Ussd.Menu;
    type MenuItem = Ussd.MenuItem;
    type MenuOptions = Ussd.MenuOption;
    type MenuError = Ussd.MenuError;

    type Run = Ussd.Run;
    type NextHandler = Ussd.NextHandler;
    type NextHandlerResp = Ussd.NextHandlerResp;

    type Args = Ussd.Args;
    type Session = Ussd.Session;

    public class MenuBuilder(
        // pass dependencies to the builder, that can be used in
        // the menu handler functions to read/update canister state
        userSvc : UserService.UserService,
        notifSvc : NotificationService.NotificationService,
    ) {
        // menu info
        let menuId = "bank-ussd-app";
        let menuDescription = "Bank ussd app";

        // menu item IDs
        let loginMenu = "loginMenu";
        let forgotPinMenu = "forgotPinMenu";
        let wrongPinMenu = "wrongPinMenu";
        let resetPinMenu = "resetPinMenu";
        let contactInfoMenu = "contactInfoMenu";
        let mainMenu = "mainMenu";
        let accBalanceMenu = "accBalanceMenu";
        let notAvailableMenu = "notAvailableMenu";
        let byeMenu = "byeMenu";

        /// Build the Ussd app menu
        public func build() : Menu {
            let menu : Menu = newMenu(menuId, menuDescription, startSession);

            // build and add menu items to the ussd menu
            addMenuItem(menu, loginMenuItem());
            addMenuItem(menu, mainMenuItem());
            addMenuItem(menu, accBalanceMenuItem());
            addMenuItem(menu, forgotPinMenuItem());
            addMenuItem(menu, resetPinMenuItem());
            addMenuItem(menu, wrongPinMenuItem());
            addMenuItem(menu, contactInfoMenuItem());
            addMenuItem(menu, notAvailableMenuItem());
            addMenuItem(menu, byeMenuItem());

            menu;
        };

        /// init session with data if any and return the first menu to run
        func startSession(_ : Args, s : Session) : async* NextHandlerResp {
            // this handler could be used to determine the start menu
            // e.g by checking if the user is already registered, one can
            // determine wether the register menu or the login menu will be the first
            // menu to be displayed
            (loginMenu, s);
        };

        /// login menu item
        func loginMenuItem() : MenuItem {
            let nextHandler = func(a : Args, s : Session) : async* NextHandlerResp {
                switch (a.replyText) {
                    case ("0") (forgotPinMenu, s);
                    case (pin) {
                        let authenticated = userSvc.authenticateUser(a.phoneNumber, pin);
                        (if (authenticated) mainMenu else wrongPinMenu, s);
                    };
                };
            };

            newMenuItem(
                loginMenu,
                noop,
                "Welcome to D-Bank. Please enter your PIN (If forgotten enter 0)",
                ?nextHandler,
            );
        };

        /// main menu item
        func mainMenuItem() : MenuItem {
            newMenuItemWithOptions(
                mainMenu,
                func(a : Args, s : Session) : async* Session {
                    saveData(s, "name", userSvc.getUserName(a.phoneNumber));
                },
                "Hello {name}, Welcome to D-Bank.",
                [
                    newMenuOption("1", "Account Balance", ?accBalanceMenu, null),
                    newMenuOption("2", "Send/Transfer Money", ?notAvailableMenu, null),
                    newMenuOption("3", "Withdraw Cash", ?notAvailableMenu, null),
                    newMenuOption("4", "Loan Application", ?notAvailableMenu, null),
                    newMenuOption("5", "Reset PIN", ?notAvailableMenu, null),
                    newMenuOption("0", "Exit", ?byeMenu, null),
                ],
            );
        };

        /// account balance menu item
        func accBalanceMenuItem() : MenuItem = newMenuItemWithOptions(
            accBalanceMenu,
            func(a : Args, s : Session) : async* Session {
                let (current, available) = userSvc.getAccountBalance(a.phoneNumber);
                saveData(s, "currentBal", "USD " # Float.toText(current))
                |> saveData(_, "availableBal", "USD " # Float.toText(available));
            },
            "Current balance is {currentBal}. Available balance is {availableBal}",
            [
                newMenuOption("0", "Back", ?mainMenu, null),
                newMenuOption("00", "Exit", ?byeMenu, null),
            ],
        );

        /// forgot pin menu item
        func forgotPinMenuItem() : MenuItem {
            let resetPinNextHandler = func(a : Args, s : Session) : async* NextHandlerResp {
                await notifSvc.sendSms(
                    a.phoneNumber,
                    "Click on the following link to reset your pin https://link.example",
                );
                (resetPinMenu, s);
            };

            newMenuItemWithOptions(
                forgotPinMenu,
                noop,
                "Welcome to D-Bank",
                [
                    newMenuOption("1", "Unlock/Reset PIN", null, ?resetPinNextHandler),
                    newMenuOption("2", "Contact Info", ?contactInfoMenu, null),
                    newMenuOption("0", "Exit", ?byeMenu, null),
                ],
            );
        };

        /// reset pin menu item
        func resetPinMenuItem() : MenuItem = newMenuItem(
            resetPinMenu,
            noop,
            "An SMS containing a password reset link has been sent to your mobile.",
            null,
        );

        /// wrong pin menu item
        func wrongPinMenuItem() : MenuItem = newMenuItem(
            wrongPinMenu,
            noop,
            "You entered the wrong PIN.",
            null,
        );

        /// contact info menu item
        func contactInfoMenuItem() : MenuItem = newMenuItem(
            contactInfoMenu,
            noop,
            "Call us on 07XX-XXX-XXX or email us at help@d-bank.com.",
            null,
        );

        /// not available menu item
        func notAvailableMenuItem() : MenuItem = newMenuItem(
            notAvailableMenu,
            noop,
            "Sorry, this service is not available. Please try again later.",
            null,
        );

        /// good bye menu item
        func byeMenuItem() : MenuItem = newMenuItem(
            byeMenu,
            noop,
            "Good bye",
            null,
        );

        /// menu item Run handler that returns the current session without performing any operation
        func noop(_ : Args, s : Session) : async* Session = async* s;
    };

};
