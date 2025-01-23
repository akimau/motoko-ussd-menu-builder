import Session "Session";
import Args "Args";

module Func {
    type Args = Args.Args;
    type Session = Session.Session;

    public type Run = (args : Args, session : Session) -> Session;
    public type NextHandler = (args : Args, session : Session) -> (?Text, Session);
};
