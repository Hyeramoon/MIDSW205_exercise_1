/*
SQL codes to produce the table with correlation between average scores for
hospital quality with patient survey responses
Explanation of the approach and results in separate file hospitals_and_patients.txt

Need to run best_hospitals.sql to create table best_hospitals_75_percentile
If not, please rerun the following:

CREATE TABLE best_hospitals_75_percentile AS
SELECT hospital_id, avg(CAST(top_25_percent AS DOUBLE))*100 as percentage_over_75th_percentile,
count(hospital_id) as number_of_scores
FROM quality_care
GROUP BY hospital_id
HAVING number_of_scores >= 15
ORDER BY percentage_over_75th_percentile DESC;
*/


CREATE TABLE quality_from_measure_and_survey AS
SELECT best_hospitals_75_percentile.hospital_id, percentage_over_75th_percentile,
surveys.hcahps_base_score + surveys.hcahps_consistency_score AS sum_score_from_patients
FROM best_hospitals_75_percentile INNER JOIN surveys
ON best_hospitals_75_percentile.hospital_id = surveys.hospital_id;

CREATE TABLE corr_measure_and_survey AS
SELECT corr(percentage_over_75th_percentile, CAST(sum_score_from_patients AS DOUBLE))
FROM quality_from_measure_and_survey;

/*
Correlation result:
0.23282079035956801
So weak correlation but still positively correlated
*/
