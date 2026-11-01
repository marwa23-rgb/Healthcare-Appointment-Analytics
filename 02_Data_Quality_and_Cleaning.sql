USE healthcare_analytics;

-- 1. Dataset size
SELECT COUNT(*) AS total_records
FROM appointments_raw;

-- 2. Duplicate appointment IDs (the primary key also prevents duplicates
--    when the table is loaded successfully).
SELECT AppointmentID, COUNT(*) AS duplicate_count
FROM appointments_raw
GROUP BY AppointmentID
HAVING COUNT(*) > 1;

-- 3. Invalid ages
SELECT *
FROM appointments_raw
WHERE Age < 0 OR Age > 110;

-- 4. Parse source date strings and inspect negative waiting days.
-- The source stores timestamps in ISO-8601 format, e.g. 2016-04-29T18:38:08Z.
WITH parsed AS (
    SELECT
        AppointmentID,
        STR_TO_DATE(REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''),
                    '%Y-%m-%d %H:%i:%s') AS scheduled_dt,
        STR_TO_DATE(REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''),
                    '%Y-%m-%d %H:%i:%s') AS appointment_dt
    FROM appointments_raw
)
SELECT
    AppointmentID,
    scheduled_dt,
    appointment_dt,
    DATEDIFF(appointment_dt, scheduled_dt) AS waiting_days
FROM parsed
WHERE scheduled_dt IS NULL
   OR appointment_dt IS NULL
   OR DATEDIFF(appointment_dt, scheduled_dt) < 0;

-- 5. Check category values and missing fields
SELECT Gender, COUNT(*) AS records
FROM appointments_raw
GROUP BY Gender;

SELECT `No-show`, COUNT(*) AS records
FROM appointments_raw
GROUP BY `No-show`;

SELECT
    SUM(PatientId IS NULL) AS null_patient_ids,
    SUM(Gender IS NULL OR Gender = '') AS missing_gender,
    SUM(ScheduledDay IS NULL OR ScheduledDay = '') AS missing_scheduled_day,
    SUM(AppointmentDay IS NULL OR AppointmentDay = '') AS missing_appointment_day,
    SUM(Neighbourhood IS NULL OR Neighbourhood = '') AS missing_neighbourhood
FROM appointments_raw;
