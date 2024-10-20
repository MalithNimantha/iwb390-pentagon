import ballerinax/mongodb;

configurable string userName = ?;
configurable string password = ?;

mongodb:Client mongoDb = check new ({
    connection: "mongodb+srv://"+userName+":"+password+"@cluster0.02jfgy5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
});

public final mongodb:Database jobsDb;

function init() returns error? {
    jobsDb = check mongoDb->getDatabase("jobs");
}

isolated function getJob(mongodb:Database jobsDb, int phoneNumber) returns Job|error {
    mongodb:Collection jobs = check jobsDb->getCollection("jobs");
    stream<Job, error?> findResult = check jobs->find({phoneNumber});
    Job[] result = check from Job m in findResult
        select m;
    if result.length() != 1 {
        return error(string `Failed to find a job with ${phoneNumber}`);
    }
    return result[0];
}