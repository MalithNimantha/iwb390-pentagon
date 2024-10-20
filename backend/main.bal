import ballerina/http;
import ballerinax/mongodb;


service on new http:Listener(9091) {
    resource function get jobs() returns Job[]|error {
        mongodb:Collection jobs = check jobsDb->getCollection("jobs");
        stream<Job, error?> result = check jobs->find();
        return from Job j in result
            select j;
    }
}
