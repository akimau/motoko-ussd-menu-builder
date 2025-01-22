import Session "Session";
import Args "Args";

module Func {
    type Args = Args.Args;
    type Session = Session.Session;

    public type Func = (args : Args, session : Session) -> Session;
};
