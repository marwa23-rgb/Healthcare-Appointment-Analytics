USE healthcare_analytics;

-- No-show rate by gender, SMS, and scholarship
SELECT
    Gender,
    COUNT(*) AS appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(100.0 * AVG(`No-show` = 'Yes'), 2) AS no_show_rate_pct
FROM appointments_raw
GROUP BY Gender
ORDER BY no_show_rate_pct DESC;

SELECT
    SMS_received,
    COUNT(*) AS appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(100.0 * AVG(`No-show` = 'Yes'), 2) AS no_show_rate_pct
FROM appointments_raw
GROUP BY SMS_received;

SELECT
    Scholarship,
    COUNT(*) AS appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(100.0 * AVG(`No-show` = 'Yes'), 2) AS no_show_rate_pct
FROM appointments_raw
GROUP BY Scholarship;

-- No-show rate by age group
WITH age_segments AS (
    SELECT
        CASE
            WHEN Age < 0 THEN 'Invalid age'
            WHEN Age <= 17 THEN '0-17'
            WHEN Age <= 29 THEN '18-29'
            WHEN Age <= 44 THEN '30-44'
            WHEN Age <= 59 THEN '45-59'
            ELSE '60+'
        END AS age_group,
        (`No-show` = 'Yes') AS no_show_flag
    FROM appointments_raw
)
SELECT
    age_group,
    COUNT(*) AS appointments,
    ROUND(100.0 * AVG(no_show_flag), 2) AS no_show_rate_pct
FROM age_segments
GROUP BY age_group
ORDER BY age_group;

-- Neighborhood ranking using a window function.
-- HAVING-style filtering is applied in the outer query to avoid ranking
-- neighborhoods with very small appointment volumes.
WITH neighborhood_rates AS (
    SELECT
        Neighbourhood,
        COUNT(*) AS appointments,
        SUM(`No-show` = 'Yes') AS missed_appointments,
        AVG(`No-show` = 'Yes') AS no_show_rate
    FROM appointments_raw
    GROUP BY Neighbourhood
),
ranked_neighborhoods AS (
    SELECT
        Neighbourhood,
        appointments,
        missed_appointments,
        ROUND(100 * no_show_rate, 2) AS no_show_rate_pct,
        DENSE_RANK() OVER (ORDER BY no_show_rate DESC) AS no_show_rate_rank
    FROM neighborhood_rates
    WHERE appointments >= 100
)
SELECT *
FROM ranked_neighborhoods
ORDER BY no_show_rate_rank, appointments DESC;

-- Rank booking lead-time groups by no-show rate.
WITH parsed AS (
    SELECT
        CASE
            WHEN DATEDIFF(
                STR_TO_DATE(REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''),
                            '%Y-%m-%d %H:%i:%s'),
                STR_TO_DATE(REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''),
                            '%Y-%m-%d %H:%i:%s')
            ) = 0 THEN 'Same day'
            WHEN DATEDIFF(
                STR_TO_DATE(REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''),
                            '%Y-%m-%d %H:%i:%s'),
                STR_TO_DATE(REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''),
                            '%Y-%m-%d %H:%i:%s')
            ) BETWEEN 1 AND 7 THEN '1-7 days'
            WHEN DATEDIFF(
                STR_TO_DATE(REPLACE(REPLACE(AppointmentDay, 'T', ' '), 'Z', ''),
                            '%Y-%m-%d %H:%i:%s'),
                STR_TO_DATE(REPLACE(REPLACE(ScheduledDay, 'T', ' '), 'Z', ''),
                            '%Y-%m-%d %H:%i:%s')
            ) BETWEEN 8 AND 30 THEN '8-30 days'
            ELSE '31+ days'
        END AS lead_time_group,
        (`No-show` = 'Yes') AS no_show_flag
    FROM appointments_raw
)
SELECT
    lead_time_group,
    COUNT(*) AS appointments,
    ROUND(100 * AVG(no_show_flag), 2) AS no_show_rate_pct,
    DENSE_RANK() OVER (ORDER BY AVG(no_show_flag) DESC) AS no_show_rate_rank
FROM parsed
GROUP BY lead_time_group
ORDER BY no_show_rate_rank;
