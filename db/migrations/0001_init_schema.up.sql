CREATE TABLE "Account" (
    "Id"        INT PRIMARY KEY,
    "Name"      VARCHAR(100) NOT NULL,
    "Category"  VARCHAR(20) NOT NULL CHECK ("Category" IN ('Asset', 'Liability', 'Equity', 'Revenue', 'Expense')),

    "CreatedAt" TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE "User" (
    "Id"                UUID PRIMARY KEY,
    "Email"             VARCHAR(255) UNIQUE NOT NULL,
    "Password"          VARCHAR(255) NOT NULL,

    "CreatedAt"         TIMESTAMP DEFAULT NOW() NOT NULL,
    "LastUpdateAt"      TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE "LedgerEntry" (
    "AccountId"         INT PRIMARY KEY REFERENCES "Account" ("Id") ON DELETE RESTRICT,

    "TotalBalance"      DECIMAL(15,2) DEFAULT 0.00 NOT NULL,

    "CreatedAt"         TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE "SubledgerEntry" (
    "UserId"        UUID REFERENCES "User" ("Id") ON DELETE RESTRICT,
    "AccountId"     INT REFERENCES  "Account" ("Id") ON DELETE RESTRICT,

    "TotalBalance"  DECIMAL(15,2) DEFAULT 0.00 NOT NULL,

    PRIMARY KEY ("UserId", "AccountId"),

    "CreatedAt"     TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE "TransactionJournal" (
    "Id"                INT PRIMARY KEY,
    "Name"              VARCHAR(255) NOT NULL,
    "Type"              VARCHAR(20) DEFAULT 'GENERAL' NOT NULL CHECK ("Type" IN ('GENERAL')),

    "UserId"            UUID REFERENCES "User" ("Id") ON DELETE RESTRICT,

    "CreatedAt"         TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE "TransactionLog" (
    "Id"            UUID PRIMARY KEY,
    "Description"   VARCHAR(255) NOT NULL,

    "UserId"        UUID REFERENCES "User" ("Id") ON DELETE RESTRICT,
    "JournalId"     INT REFERENCES "TransactionJournal" ("Id") ON DELETE RESTRICT,

    "CreatedAt"     TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE "TransactionLine" (
    "Id"            UUID PRIMARY KEY,
    "Amount"        DECIMAL(15,2) DEFAULT 0.00 NOT NULL,

    "LogId"         UUID REFERENCES "TransactionLog" ("Id") ON DELETE RESTRICT,
    "AccountId"     INT REFERENCES "Account" ("Id") ON DELETE RESTRICT,

    "CreatedAt"     TIMESTAMP DEFAULT NOW() NOT NULL
);