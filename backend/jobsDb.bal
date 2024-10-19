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