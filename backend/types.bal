public type Job record {|
    readonly string id;
    *JobInput;
|};

public type JobInput record {|
    string description;
    int phoneNumber;
    string status;
|};

public type JobUpdate record {|
    string description;
    int phoneNumber;
    string status;
|};
