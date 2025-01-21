import { getReplyText } "../../src/Ussd/modules/Args";

assert getReplyText("") == null;
assert getReplyText(" ") == null;
assert getReplyText("1") == ?"1";
assert getReplyText("1*2*3*1*john doe") == ?"john doe";
