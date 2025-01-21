import { new } "../../src/Ussd/modules/Args";

let tArgs = new("sessionid", "phonenumber", "servicecode", "1*2*hello world!");

let tExpected = {
    sessionId = "sessionid";
    phoneNumber = "phonenumber";
    serviceCode = "servicecode";
    text = "1*2*hello world!";
    replyText = "hello world!";
};

assert tArgs == tExpected;
