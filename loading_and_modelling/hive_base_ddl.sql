/* DDL SQL statements for each base files loaded into HDFS */

CREATE EXTERNAL TABLE hospitals_raw (
hospital_id STRING,
hospital_name STRING,
address STRING,
city STRING,
state STRING,
zip_code INT,
county STRING,
phone_number INT,
hospital_type STRING,
hospital_owner STRING,
emergency_svc STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
 "separatorChar" = ",",
 "quoteChar" = "/""",
 "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/hospitals';


CREATE EXTERNAL TABLE effective_care_raw (
hospital_id STRING,
hospital_name STRING,
address	STRING,
city STRING,
state STRING,
zip_code INT,
county STRING,
phone_number INT,
condition STRING,
measure_id STRING,
measure_name STRING,
score STRING,
sample	STRING,
footnote STRING,
measure_start_date STRING,
measure_end_date STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
 "separatorChar" = ",",
 "quoteChar" = "/"",
 "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/care';


CREATE EXTERNAL TABLE IF NOT EXISTS readmissions_raw (
hospital_id STRING,
hospital_name STRING,
address	STRING,
city STRING,
state STRING,
zip_code INT,
county STRING,
phone_number INT,
measure_name STRING,
measure_id STRING,
compared_national STRING,
denominator STRING,
score STRING,
lower_est STRING,
higher_est STRING,
footnote STRING,
measure_start_date STRING,
measure_end_date STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
 "separatorChar" = ",",
 "quoteChar" = "\"",
 "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/readmissions’;


CREATE EXTERNAL TABLE measures_raw (
measure_name STRING,
measure_id STRING,
measure_start_quarter STRING,
measure_start_date STRING,
measure_end_quarter STRING,
measure_end_date STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
 "separatorChar" = ",",
 "quoteChar" = "\""
 "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/measures’;


CREATE EXTERNAL TABLE surveys_raw (
hospital_id STRING,
hospital_name STRING,
address	STRING,
city STRING,
state STRING,
zip_code INT,
county STRING,
comm_nurses_achievement STRING,
comm_nurses_improvement STRING,
comm_nurses_dimension STRING,
comm_docs_achievement STRING,
comm_docs_improvement STRING,
comm_docs_dimension STRING,
response_hosp_staff_achievement STRING,
response_hosp_staff_improvement STRING,
response_hosp_staff_dimension STRING,
pain_mgmt_achievement STRING,
pain_mgmt_improvement STRING,
pain_mgmt_dimension STRING,
comm_medicines_achievement STRING,
comm_medicines_improvement STRING,
comm_medicines_dimension STRING,
clean_quiet_hosp_achievement STRING,
clean_quiet_hosp_improvement STRING,
clean_quiet_hosp_dimension STRING,
discharge_info_achievement STRING,
discharge_info_improvement STRING,
discharge_info_dimension STRING,
overall_rating_hosp_achievement STRING,
overall_rating_hosp_improvement STRING,
overall_rating_hosp_dimension STRING,
hcahps_base_score STRING,
hcahps_consistency_score STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
 "separatorChar" = ",",
 "quoteChar" = "\"",
 "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital_compare/surveys’;
