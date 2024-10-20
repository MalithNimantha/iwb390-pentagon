import ballerina/io;
import ballerinax/twilio;

configurable string accountSid = ?;
configurable string authToken = ?;

twilio:ConnectionConfig twilioConfig = {
    auth: {
        username: accountSid,
        password: authToken
    }
};

twilio:Client twilio = check new (twilioConfig);

public function message(int phoneNumber, string jobDescription, string jobStatus) returns error? {
    twilio:CreateMessageRequest messageRequest = {
            To: "+94" + phoneNumber.toString(),
            From: "+18647744002",
            Body: "Job description : " + jobDescription + "\nJob status : " + jobStatus + "\nDon't Worry we will take care of your item untill you get back!!"
        };

    twilio:Message response = check twilio->createMessage(messageRequest);
    io:print(response);

}

