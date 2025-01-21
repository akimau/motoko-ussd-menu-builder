import Session "Session";
import MenuArgs "MenuArgs";

module MenuFunc {
    type MenuArgs = MenuArgs.MenuArgs;
    type Session = Session.Session;

    public type MenuFunc = (args : MenuArgs, session : Session) -> Session;
};
