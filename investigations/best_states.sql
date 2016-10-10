/*
SQL codes to produce the table with states with best quality care.
Explanation of the approach and results in separate file best_states.txt
*/

CREATE TABLE quality_care_state AS
SELECT quality_care.hospital_id, condition, measure_id,
score, score_unit, higher_the_better, upper_10_percent,
lower_10_percent, upper_25_percent, lower_25_percent,
top_10_percent, top_25_percent, top_50_percent, hospitals.state
FROM quality_care LEFT JOIN hospitals
ON quality_care.hospital_id = hospitals.hospital_id;


/* Note that all scores not available have been dropped from tables, thus
# the number of hospitals is equal to number of available scores */
CREATE TABLE scores_count_per_state AS
SELECT state, count(hospital_id) as count_scores
FROM quality_care_state
GROUP BY state;

SELECT PERCENTILE_APPROX(CAST(count_scores AS DOUBLE), 0.25) FROM scores_count_per_state;
/* 838 */
SELECT PERCENTILE_APPROX(CAST(count_scores AS DOUBLE), 0.10) FROM scores_count_per_state;
/* 390 */


CREATE TABLE best_states_90_percentile AS
SELECT state, avg(CAST(top_10_percent AS DOUBLE))*100 as percentage_over_90th_percentile,
count(hospital_id) as number_of_scores
FROM quality_care_state
GROUP BY state
HAVING number_of_scores >= 400
ORDER BY percentage_over_90th_percentile DESC;

SELECT * FROM best_states_90_percentile LIMIT 10;

/*
results if num >=400
id      % over 90th       #scores in calc
ME	37.439222042139384	1234
NH	33.947939262472886	922
FL	33.38503758501372	8381
CO	33.33333333333333	2331
VA	32.36594803758983	3618
WI	32.29843561973526	4155
UT	32.22468588322247	1353
MT	31.620111731843576	895
HI	31.292517006802722	588
SC	30.57692307692308	2600
*/

CREATE TABLE best_states_75_percentile AS
SELECT state, avg(CAST(top_25_percent AS DOUBLE))*100 as percentage_over_75th_percentile,
count(hospital_id) as number_of_scores
FROM quality_care_state
GROUP BY state
HAVING number_of_scores >= 400
ORDER BY percentage_over_75th_percentile DESC;

SELECT * FROM best_states_75_percentile LIMIT 10;

/*
results if num >=400
ME	46.75850891410049	1234
UT	42.572062084257205	1353
WI	42.478941034897716	4155
NH	41.757049891540134	922
CO	41.65594165594166	2331
SD	40.731995277449826	847
FL	39.70886529053812	8381
IN	39.111402932808055	4569
MT	39.10614525139665	895
VA	38.47429519071311	3618
*/

CREATE TABLE best_states_50_percentile AS
SELECT state, avg(CAST(top_50_percent AS DOUBLE))*100 as percentage_over_50th_percentile,
count(hospital_id) as number_of_scores
FROM quality_care_state
GROUP BY state
HAVING number_of_scores >= 400
ORDER BY percentage_over_50th_percentile DESC;

SELECT * FROM best_states_50_percentile LIMIT 10;

/*
results if num >=400
ME	66.0453808752026	1234
WI	65.82430806257521	4155
UT	64.96674057649668	1353
CO	63.792363792363794	2331
SD	61.747343565525384	847
NH	61.60520607375272	922
IN	60.013131976362445	4569
VA	59.03814262023217	3618
HI	58.50340136054422	588
FL	58.501372151294596	8381
*/


CREATE TABLE best_states AS
SELECT *
FROM best_states_50_percentile
ORDER BY percentage_over_50th_percentile DESC
LIMIT 10;

SELECT * FROM best_states;

/*
results if num >=400
ME	66.0453808752026	1234
WI	65.82430806257521	4155
UT	64.96674057649668	1353
CO	63.792363792363794	2331
SD	61.747343565525384	847
NH	61.60520607375272	922
IN	60.013131976362445	4569
VA	59.03814262023217	3618
HI	58.50340136054422	588
FL	58.501372151294596	8381
*/
