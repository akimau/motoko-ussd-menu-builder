import Session "Session";
import Args "Args";
import T "../types";

module Func {
    type Args = Args.Args;
    type Session = Session.Session;

    public type NextHandlerResp = (T.MenuItemId, Session);

    public type Run = (args : Args, session : Session) -> async* Session;
    public type NextHandler = (args : Args, session : Session) -> async* NextHandlerResp;
};
