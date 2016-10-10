/* Script to be run in hive

Transformations - 2 steps

STEP 1: modify tables from raw tables in load_and_modelling step
 1. Create tables with selected columns only
 2. For tables with score column:
   a) drop rows with "Not Available"
   b) add column score_unit to flag 3 types of scores: volume, time and rate
      (the types are described in the data dictionary from the CMS site)
   c) add column higher_the_better to flag whether a higher score indicates
      better care. All time scores indicate a better care when lower values.
      For most rate(percentage) scores, higher values are for better care except
      for few cases.
 3. For readmissions table, create a column condition (same name as column in
    table effective_care) to categorize the measures into death and readmission.
    This will help for grouping the measures/scores when joining this table
    with effective_care table.
*/

CREATE TABLE hospitals AS
SELECT hospital_id, hospital_name, state,
hospital_type, hospital_owner, emergency_svc
FROM hospitals_raw;


CREATE TABLE effective_care AS
SELECT hospital_id, condition, measure_id,
score, sample,
CASE WHEN measure_id = "EDV" THEN "volume"
WHEN measure_id = "OP_1" THEN "time"
WHEN measure_id = "OP_3b" THEN "time"
WHEN measure_id = "OP_5" THEN "time"
WHEN measure_id = "ED_1b" THEN "time"
WHEN measure_id = "ED_2b" THEN "time"
WHEN measure_id = "OP_18b" THEN "time"
WHEN measure_id = "OP_20" THEN "time"
WHEN measure_id = "OP_21" THEN "time"
ELSE "rate" END AS score_unit,
CASE WHEN measure_id = "EDV" THEN "no"
WHEN measure_id = "OP_1" THEN "no"
WHEN measure_id = "OP_3b" THEN "no"
WHEN measure_id = "OP_5" THEN "no"
WHEN measure_id = "ED_1b" THEN "no"
WHEN measure_id = "ED_2b" THEN "no"
WHEN measure_id = "OP_18b" THEN "no"
WHEN measure_id = "OP_20" THEN "no"
WHEN measure_id = "OP_21" THEN "no"
WHEN measure_id = "PC_01" THEN "no"
WHEN measure_id = "VTE_6" THEN "no"
WHEN measure_id = "OP_22" THEN "no"
ELSE "yes" END AS higher_the_better
FROM effective_care_raw
WHERE score <> "Not Available";


CREATE TABLE readmissions AS
SELECT hospital_id, measure_id, compared_national,
denominator, score,
CASE WHEN substring(measure_id,1,4) = "MORT" THEN "death"
ELSE "readmission" END AS condition,
CASE WHEN substring(measure_id,1,4) = "MORT" THEN "rate" ELSE "rate" END AS score_unit,
CASE WHEN substring(measure_id,1,4) = "MORT" THEN "no" ELSE "no" END AS higher_the_better
FROM readmissions_raw
WHERE score <> "Not Available";


CREATE TABLE measures AS
SELECT measure_name, measure_id, measure_start_quarter, measure_start_date,
measure_end_quarter, measure_end_date
FROM measures_raw;


CREATE TABLE surveys AS
SELECT hospital_id, hcahps_base_score, hcahps_consistency_score
FROM surveys_raw;


/*
Transformations
STEP 2:
Create additional tables:
1. score table with all measures that will count for determining quality of care
(effective_care and readmisions measures in this exercise)
2. percentiles tables for each measure_id(procedure) which will be used as a
criteria to determine quality of care
3. quality_care table with scores, percentiles of each measure_id and binary value
columsn to indicate if score higher or lower than each percentile threshold
for each set of hospital and measure_id
*/

CREATE TABLE score_all AS
SELECT hospital_id, condition, measure_id,
score, score_unit, higher_the_better FROM effective_care
UNION ALL
SELECT hospital_id, condition, measure_id,
score, score_unit, higher_the_better FROM readmissions;


CREATE TABLE score_threshold AS
SELECT measure_id,
PERCENTILE_APPROX(CAST(score AS DOUBLE), 0.9) AS upper_10_percent,
PERCENTILE_APPROX(CAST(score AS DOUBLE), 0.1) AS lower_10_percent,
PERCENTILE_APPROX(CAST(score AS DOUBLE),0.75) AS upper_25_percent,
PERCENTILE_APPROX(CAST(score AS DOUBLE),0.25) AS lower_25_percent,
PERCENTILE_APPROX(CAST(score AS DOUBLE),0.50) AS upper_50_percent,
PERCENTILE_APPROX(CAST(score AS DOUBLE),0.50) AS lower_50_percent
FROM score_all
WHERE measure_id <> "EDV"
GROUP BY measure_id
ORDER BY measure_id ASC;


CREATE TABLE quality_care AS
SELECT hospital_id, score_all.measure_id,
score, score_unit, higher_the_better, upper_10_percent,
lower_10_percent, upper_25_percent, lower_25_percent,
CASE WHEN higher_the_better="yes" and score < upper_10_percent THEN 0
WHEN higher_the_better="yes" and score >= upper_10_percent THEN 1
WHEN higher_the_better="no" and score <= lower_10_percent THEN 1
WHEN higher_the_better="no" and score > lower_10_percent THEN 0
END AS top_10_percent,
CASE WHEN higher_the_better="yes" and score < upper_25_percent THEN 0
WHEN higher_the_better="yes" and score >= upper_25_percent THEN 1
WHEN higher_the_better="no" and score <= lower_25_percent THEN 1
WHEN higher_the_better="no" and score > lower_25_percent THEN 0
END AS top_25_percent,
CASE WHEN higher_the_better="yes" and score < upper_50_percent THEN 0
WHEN higher_the_better="yes" and score >= upper_50_percent THEN 1
WHEN higher_the_better="no" and score <= lower_50_percent THEN 1
WHEN higher_the_better="no" and score > lower_50_percent THEN 0
END AS top_50_percent
FROM score_all LEFT JOIN score_threshold
ON score_all.measure_id = score_threshold.measure_id
WHERE score_all.measure_id <> "EDV";
