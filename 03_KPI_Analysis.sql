USE healthcare_analytics;

WITH parsed AS (
    SELECT
        AppointmentID,
        CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END AS no_show_flag,
        DATEDIFF(
            STR_TO_DATE(REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''),
                        '%Y-%m-%d %H:%i:%s'),
            STR_TO_DATE(REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''),
                        '%Y-%m-%d %H:%i:%s')
        ) AS waiting_days
    FROM appointments_raw
)
SELECT
    COUNT(*) AS total_appointments,
    SUM(no_show_flag) AS missed_appointments,
    COUNT(*) - SUM(no_show_flag) AS attended_appointments,
    ROUND(100.0 * SUM(no_show_flag) / COUNT(*), 2) AS no_show_rate_pct,
    ROUND(100.0 * (COUNT(*) - SUM(no_show_flag)) / COUNT(*), 2) AS attendance_rate_pct
FROM parsed;

-- Same-day booking and 31+ day lead-time KPIs
WITH parsed AS (
    SELECT
        CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END AS no_show_flag,
        DATEDIFF(
            STR_TO_DATE(REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''),
                        '%Y-%m-%d %H:%i:%s'),
            STR_TO_DATE(REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''),
                        '%Y-%m-%d %H:%i:%s')
        ) AS waiting_days
    FROM appointments_raw
)
SELECT
    CASE
        WHEN waiting_days = 0 THEN 'Same-day booking'
        WHEN waiting_days BETWEEN 1 AND 7 THEN '1-7 days'
        WHEN waiting_days BETWEEN 8 AND 30 THEN '8-30 days'
        WHEN waiting_days >= 31 THEN '31+ days'
        ELSE 'Negative / invalid'
    END AS booking_lead_time,
    COUNT(*) AS appointments,
    SUM(no_show_flag) AS missed_appointments,
    ROUND(100.0 * SUM(no_show_flag) / COUNT(*), 2) AS no_show_rate_pct
FROM parsed
GROUP BY booking_lead_time
ORDER BY MIN(waiting_days);
