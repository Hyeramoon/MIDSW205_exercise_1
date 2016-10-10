/*
SQL codes to produce the table with procedures with greatest variability
between hospitals.
Explanation of the approach and results in separate file hospital_variability.txt
*/

CREATE TABLE procedures_variability_rate_measure AS
SELECT measure_id, STDDEV_POP(CAST(score AS DOUBLE)) AS score_variability
FROM quality_care
WHERE score_unit = "rate"
GROUP BY measure_id
ORDER BY score_variability DESC
LIMIT 10;

SELECT * FROM procedures_variability_rate_measure;
/*
Results
STK_4	21.954194561164023
OP_23	21.844653491103774
AMI_7a	18.7794213613377
OP_2	18.048443797995763
IMM_3_FAC_ADHPCT	16.348047889323595
VTE_5	16.30300466996529
VTE_1	15.257401142298388
STK_8	14.013262732452308
CAC_3	12.71912110433212
IMM_2	11.944885922069522
*/


CREATE TABLE procedures_variability_time_measure AS
SELECT measure_id, STDDEV_POP(CAST(score AS DOUBLE)) AS score_variability
FROM quality_care
WHERE score_unit = "time"
GROUP BY measure_id
ORDER BY score_variability DESC
LIMIT 10;

SELECT * FROM procedures_variability_time_measure;

/*
ED_1b	92.83178787038688
ED_2b	62.1666505939829
OP_18b	40.70077322337158
OP_3b	29.479326601050527
OP_21	17.722358013930915
OP_20	16.882052975576602
OP_1	7.563457037158417
OP_5	6.109381800089665
*/
