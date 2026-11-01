CREATE DATABASE IF NOT EXISTS healthcare_analytics;
USE healthcare_analytics;

DROP TABLE IF EXISTS appointments_raw;

CREATE TABLE appointments_raw (
    PatientId       BIGINT,
    AppointmentID   BIGINT NOT NULL,
    Gender          CHAR(1),
    ScheduledDay    VARCHAR(30),
    AppointmentDay  VARCHAR(30),
    Age             INT,
    Neighbourhood   VARCHAR(100),
    Scholarship     TINYINT,
    Hipertension    TINYINT,
    Diabetes        TINYINT,
    Alcoholism      TINYINT,
    Handcap         TINYINT,
    SMS_received    TINYINT,
    `No-show`       VARCHAR(5),
    PRIMARY KEY (AppointmentID)
);

