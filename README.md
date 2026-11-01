# Healthcare Appointment No-Show Analytics

<p align="center">
  <img src="https://img.shields.io/badge/Healthcare-Analytics-8B72BE?style=for-the-badge" alt="Healthcare Analytics"/>
  <img src="https://img.shields.io/badge/SQL-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL"/>
  <img src="https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" alt="Power BI"/>
</p>

## 📌 Project Overview

This project analyzes 110,527 medical appointment records to understand patterns associated with missed appointments (no-shows) and identify patient segments that may benefit from targeted interventions.

MySQL is used for data-quality checks, KPI calculations, segmentation, and window-function analysis. Power BI is the recommended visualization layer for interactive reporting.

## 🎯 Business Questions

- What is the overall patient no-show rate?
- How does the time between scheduling and the appointment relate to attendance?
- Which age groups and neighborhoods have higher no-show rates?
- Are there differences by gender, SMS reminder receipt, or scholarship status?
- Which segments could be prioritized for further investigation and outreach?

## 📊 Headline Results

| KPI | Result |
|---|---:|
| Total appointments | 110,527 |
| Attended appointments | 88,208 |
| Missed appointments | 22,319 |
| Overall no-show rate | 20.19% |
| Same-day booking no-show rate | 4.65% |
| Booking 31+ days ahead no-show rate | 33.00% |
| Neighborhoods represented | 81 |

### No-Show Rate by Segment

| Segment | Group | No-Show Rate |
|---|---|---:|
| Gender | Female | 20.31% |
| Gender | Male | 19.97% |
| SMS received | No | 16.70% |
| SMS received | Yes | 27.57% |
| Scholarship | No | 19.81% |
| Scholarship | Yes | 23.74% |

## 💡 Key Insights

- Around one in five scheduled appointments was missed.
- Appointments booked 31+ days ahead had a 33.00% no-show rate, compared with 4.65% for same-day bookings.
- The observed no-show rate was higher among patients who received SMS reminders (27.57%) than among those who did not (16.70%). This is an association, not evidence that reminders cause missed appointments; reminder targeting may differ by patient risk.
- Gender differences were comparatively small in this dataset.
- The scholarship group had a higher observed no-show rate (23.74%) than the non-scholarship group (19.81%).
- Neighborhood-level variation can help identify areas for further operational investigation.

## 📈 Recommended Power BI Dashboard Pages

1. **Executive Overview:** appointments, attended, missed, no-show rate, and attendance rate.
2. **Patient Demographics:** no-show rate by age group and gender.
3. **Appointment Behavior:** waiting days and booking lead-time categories.
4. **SMS & Scholarship:** attendance comparison by reminder and scholarship status.
5. **Neighborhood Analysis:** neighborhood ranking, appointment volume, and no-show rate.

## 🧠 Business Recommendations

- Review long booking lead times and consider confirmation or follow-up workflows for appointments scheduled far in advance.
- Evaluate SMS timing, message content, and targeting. Do not conclude that SMS increases no-shows from this observational comparison.
- Investigate neighborhoods with elevated no-show rates while considering appointment volume and access barriers.
- Test targeted interventions and compare outcomes before scaling them.
- Monitor both no-show rate and appointment volume to avoid prioritizing small segments based on unstable rates.

## ⚠️ Data Quality & Metric Definitions

The supplied CSV contains 110,527 rows and 14 columns. Validation found:
- No duplicate `AppointmentID` values.
- One negative age value (`Age = -1`).
- Five records with negative waiting days when comparing calendar dates.
- 81 distinct neighborhoods.

**Metric definitions**
- **No-Show Rate:** missed appointments / total appointments × 100.
- **Attendance Rate:** attended appointments / total appointments × 100.
- **Waiting Days:** calendar date of appointment minus calendar date of scheduling.
- **Same-Day Booking:** waiting days = 0.
- **31+ Days Ahead:** waiting days >= 31.

Invalid values are flagged for investigation rather than silently removed from the source file. Headline rates above are calculated on all 110,527 supplied records, matching the stated project KPIs.

## 🛠️ Tools & Technologies

- **MySQL 8.0+:** data exploration, quality checks, aggregations, CTEs, and window functions.
- **Power BI:** intended interactive dashboard and drill-down reporting.
- **CSV:** original appointment dataset.

## 🚀 How to Use

1. Create the database and raw table by running `SQL/01_Create_Database_and_Raw_Table.sql`.
2. Import `Dataset/KaggleV2-May-2016.csv` into `appointments_raw` using MySQL Workbench's Table Data Import Wizard. Map columns by name and retain the header row as column names.
3. Run `SQL/02_Data_Quality_and_Cleaning.sql` to inspect data quality.
4. Run `SQL/03_KPI_Analysis.sql` for headline KPIs.
5. Run `SQL/04_Segment_Analysis_and_Window_Functions.sql` for segment comparisons and rankings.
6. Build the Power BI report and save it under `PowerBI/`.

The SQL uses MySQL 8.0+ features, including common table expressions and window functions.

## 📂 Repository Structure

```text
Healthcare-Appointment-No-Show-Analytics/
│
├── Dataset/
│   └── KaggleV2-May-2016.csv
│
├── SQL/
│   ├── 01_Create_Database_and_Raw_Table.sql
│   ├── 02_Data_Quality_and_Cleaning.sql
│   ├── 03_KPI_Analysis.sql
│   └── 04_Segment_Analysis_and_Window_Functions.sql
│
├── PowerBI/
│   └── README.md
│
├── Dashboard_Screenshots/
│   └── README.md
│
└── README.md
```

## 👩‍💻 Author

**Marwa Samy** · [GitHub](https://github.com/marwa23-rgb)
