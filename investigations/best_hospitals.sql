/*
SQL codes to produce the table with hospitals with best quality care.
Explanation of the approach and results in separate file best_hospitals.txt
*/

/* Note that all scores not available have been dropped from tables, thus
# the number of hospitals is equal to number of available scores */
CREATE TABLE scores_count_per_hospital AS
SELECT hospital_id, count(hospital_id) as count_hosp
FROM quality_care
GROUP BY hospital_id;

SELECT PERCENTILE_APPROX(CAST(count_hosp AS DOUBLE), 0.25) FROM scores_count_per_hospital;
/* 25th percentile is 14 scores, thus will discard all hospitals with small number
of scores, that is, less or equal than 14 scores to keep the most significant
hospitals and more credible results */


CREATE TABLE best_hospitals_90_percentile AS
SELECT hospital_id, avg(CAST(top_10_percent AS DOUBLE))*100 as percentage_over_90th_percentile,
count(hospital_id) as number_of_scores
FROM quality_care
GROUP BY hospital_id
HAVING number_of_scores >= 15
ORDER BY percentage_over_90th_percentile DESC;

SELECT * FROM best_hospitals_90_percentile LIMIT 10;

/*
results if num >= 15
id      % over 90th       #scores in calc
450780	88.23529411764706	17
450851	88.0	            25
670049	83.33333333333334	18
450804	82.35294117647058	17
450845	73.68421052631578	19
050111	73.07692307692307	26
450766	72.72727272727273	22
100008	71.69811320754717	53
050541	71.42857142857143	35
100070	71.15384615384616	52
*/

CREATE TABLE best_hospitals_75_percentile AS
SELECT hospital_id, avg(CAST(top_25_percent AS DOUBLE))*100 as percentage_over_75th_percentile,
count(hospital_id) as number_of_scores
FROM quality_care
GROUP BY hospital_id
HAVING number_of_scores >= 15
ORDER BY percentage_over_75th_percentile DESC;

SELECT * FROM best_hospitals_75_percentile LIMIT 10;

/*
results if num >=15
450780	94.11764705882352	17  90th
450422	88.23529411764706	17
450851	88.0	            25  90th
450845	84.21052631578947	19  90th
670049	83.33333333333334	18  90th
390138	82.97872340425532	47
450804	82.35294117647058	17  90th
450766	81.81818181818183	22  90th
670059	80.95238095238095	21
050111	80.76923076923077	26  90th
*/

CREATE TABLE best_hospitals AS
SELECT best_hospitals_75_percentile.hospital_id,
hospitals.hospital_name,
best_hospitals_75_percentile.percentage_over_75th_percentile,
best_hospitals_75_percentile.number_of_scores
FROM best_hospitals_75_percentile INNER JOIN hospitals
ON best_hospitals_75_percentile.hospital_id = hospitals.hospital_id
ORDER BY best_hospitals_75_percentile.percentage_over_75th_percentile DESC
LIMIT 10;

SELECT * FROM best_hospitals;
