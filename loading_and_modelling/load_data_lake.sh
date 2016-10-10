#! /bin/bash

# Create a directory to load files
mkdir ~/tempdata
cd ~/tempdata


# Load zip file from CMS source and unzip files
wget https://data.medicare.gov/views/bg9k-emty/files/Nqcy71p9Ss2RSBWDmP77H1DQXcyacr2khotGbDHHW_s?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_Flatfiles.zip
mv "Nqcy71p9Ss2RSBWDmP77H1DQXcyacr2khotGbDHHW_s?content_type=application%2Fzip; charset=binary" hospital.zip
unzip hospital.zip


# Rename files
mv "Hospital General Information.csv" "hospitals.csv"
mv "Timely and Effective Care - Hospital.csv" "effective_care.csv"
mv "Readmissions and Deaths - Hospital.csv" "readmissions.csv"
mv "Measure Dates.csv" "Measures.csv"
mv "hvbp_hcahps_05_28_2015.csv" "surveys_responses.csv"


# Remove first line (header) in each files
tail -n +2 "hospitals.csv" > "hospitals.tmp" && mv "hospitals.tmp" "hospitals.csv"
tail -n +2 "effective_care.csv" > "effective_care.tmp" && mv "effective_care.tmp" "effective_care.csv"
tail -n +2 "readmissions.csv" > "readmissions.tmp" && mv "readmissions.tmp" "readmissions.csv"
tail -n +2 "Measures.csv" > "Measures.tmp" && mv "Measures.tmp" "Measures.csv"
tail -n +2 "surveys_responses.csv" > "surveys_responses.tmp" && mv "surveys_responses.tmp" "surveys_responses.csv"


# Create new directory "hospital_compare" and subdirectories to load files in hdfs
hdfs dfs -mkdir /user/w205/hospital_compare

hdfs dfs -mkdir /user/w205/hospital_compare/hospitals
hdfs dfs -put hospitals.csv /user/w205/hospital_compare/hospitals

hdfs dfs -mkdir /user/w205/hospital_compare/care
hdfs dfs -put effective_care.csv /user/w205/hospital_compare/care

hdfs dfs -mkdir /user/w205/hospital_compare/readmissions
hdfs dfs -put readmissions.csv /user/w205/hospital_compare/readmissions

hdfs dfs -mkdir /user/w205/hospital_compare/measures
hdfs dfs -put Measures.csv /user/w205/hospital_compare/measures

hdfs dfs -mkdir /user/w205/hospital_compare/surveys
hdfs dfs -put surveys_responses.csv /user/w205/hospital_compare/surveys
