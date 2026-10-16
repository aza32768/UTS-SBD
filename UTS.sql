CREATE TABLE Client (
    clientNo VARCHAR(10) PRIMARY KEY
);

CREATE TABLE PrivateOwner (
    ownerNo VARCHAR(10) PRIMARY KEY
);

CREATE TABLE BusinessOwner (
    ownerNo VARCHAR(10) PRIMARY KEY
);

CREATE TABLE Newspaper (
    newspaperName VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Branch (
    branchNo VARCHAR(10) PRIMARY KEY,
    mgrStaffNo VARCHAR(10)
);

CREATE TABLE Telephone (
    telNo VARCHAR(20) PRIMARY KEY,
    branchNo VARCHAR(10) NOT NULL,
    FOREIGN KEY (branchNo) REFERENCES Branch(branchNo) ON DELETE CASCADE
);

CREATE TABLE Staff (
    staffNo VARCHAR(10) PRIMARY KEY,
    supervisorStaffNo VARCHAR(10),
    branchNo VARCHAR(10) NOT NULL,
    FOREIGN KEY (supervisorStaffNo) REFERENCES Staff(staffNo) ON DELETE SET NULL,
    FOREIGN KEY (branchNo) REFERENCES Branch(branchNo) ON DELETE CASCADE
);

CREATE TABLE Manager (
    staffNo VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (staffNo) REFERENCES Staff(staffNo) ON DELETE CASCADE
);

ALTER TABLE Branch
ADD CONSTRAINT fk_branch_manager FOREIGN KEY (mgrStaffNo) REFERENCES Manager(staffNo) ON DELETE SET NULL;

CREATE TABLE Registration (
    clientNo VARCHAR(10) PRIMARY KEY,
    branchNo VARCHAR(10) NOT NULL,
    staffNo VARCHAR(10) NOT NULL,
    FOREIGN KEY (clientNo) REFERENCES Client(clientNo) ON DELETE CASCADE,
    FOREIGN KEY (branchNo) REFERENCES Branch(branchNo) ON DELETE CASCADE,
    FOREIGN KEY (staffNo) REFERENCES Staff(staffNo) ON DELETE CASCADE
);

CREATE TABLE PropertyForRent (
    propertyNo VARCHAR(10) PRIMARY KEY,
    ownerNo VARCHAR(10) NOT NULL,
    staffNo VARCHAR(10),
    branchNo VARCHAR(10) NOT NULL,
    FOREIGN KEY (staffNo) REFERENCES Staff(staffNo) ON DELETE SET NULL,
    FOREIGN KEY (branchNo) REFERENCES Branch(branchNo) ON DELETE CASCADE
    
);

CREATE TABLE Lease (
    leaseNo VARCHAR(10) PRIMARY KEY,
    clientNo VARCHAR(10) NOT NULL,
    propertyNo VARCHAR(10) NOT NULL,
    FOREIGN KEY (clientNo) REFERENCES Client(clientNo) ON DELETE CASCADE,
    FOREIGN KEY (propertyNo) REFERENCES PropertyForRent(propertyNo) ON DELETE CASCADE
);

CREATE TABLE Viewing (
    clientNo VARCHAR(10) NOT NULL,
    propertyNo VARCHAR(10) NOT NULL,
    PRIMARY KEY (clientNo, propertyNo),
    FOREIGN KEY (clientNo) REFERENCES Client(clientNo) ON DELETE CASCADE,
    FOREIGN KEY (propertyNo) REFERENCES PropertyForRent(propertyNo) ON DELETE CASCADE
);

CREATE TABLE Advert (
    propertyNo VARCHAR(10) NOT NULL,
    newspaperName VARCHAR(100) NOT NULL,
    dateAdvert DATE NOT NULL,
    PRIMARY KEY (propertyNo, newspaperName, dateAdvert),
    FOREIGN KEY (propertyNo) REFERENCES PropertyForRent(propertyNo) ON DELETE CASCADE,
    FOREIGN KEY (newspaperName) REFERENCES Newspaper(newspaperName) ON DELETE CASCADE
);