import ballerina/http;
import ballerinax/mongodb;
import ballerina/uuid;
import backend.messageOp;
import ballerina/io;


service on new http:Listener(9091) {
    resource function get jobs() returns Job[]|error {
        mongodb:Collection jobs = check jobsDb->getCollection("jobs");
        stream<Job, error?> result = check jobs->find();
        return from Job j in result
            select j;
    }

    resource function get jobs/[int phoneNumber]() returns Job|error {
        return getJob(jobsDb, phoneNumber);
    }


    resource function post jobs(JobInput input) returns Job|error {
        string id = uuid:createType1AsString();
        Job job = {id, ...input};
        mongodb:Collection jobs = check jobsDb->getCollection("jobs");
        check jobs->insertOne(job);
        error? message = messageOp:message(input.phoneNumber, input.description, input.status);
        io:print(message);
        return job;
    }

    resource function put jobs/[int phoneNumber](JobUpdate update) returns JobUpdate|error {
        mongodb:Collection jobs = check jobsDb->getCollection("jobs");
        mongodb:UpdateResult updateResult = check jobs->updateOne({phoneNumber}, {set: update});
        if updateResult.modifiedCount != 1 {
            return error(string `Failed to update the job with ${phoneNumber}`);
        }
        error? message = messageOp:message(update.phoneNumber, update.description, update.status);
        io:print(message);
        return update;
    }

    resource function delete jobs/[int phoneNumber](JobUpdate update) returns string|error {
        mongodb:Collection jobs = check jobsDb->getCollection("jobs");
        mongodb:DeleteResult deleteResult = check jobs->deleteOne({phoneNumber});
        if deleteResult.deletedCount != 1 {
            return error(string `Failed to delete the job ${phoneNumber}`);
        }
        error? message = messageOp:message(update.phoneNumber, update.description, update.status);
        io:print(message);
        return "Successfully deleted the job";
    }



}