#!/bin/sh
# Runs the PageRank algorithm with MapReduce for 10 iterations, for 10 repetitions
# Usage: ./pagerank-hadoop.sh
source ./configure_env.sh

INPUT_FILE="medium.txt"
RESULT_FILE="/home/ddps2224/pagerank-hadoop-result.txt"

# Delete old results file
rm ${RESULT_FILE}

# Add files to HDFS
hadoop fs -mkdir -p /user/ddps2224
#hadoop fs -rm ${INPUT_FILE}
hadoop fs -put /var/scratch/ddps2224/datasets/${INPUT_FILE}

for i in $(seq 1 ${NUM_REPETITIONS})
do 
	yarn jar bin/hadoop-pagerank.jar  --input /user/ddps2224/${INPUT_FILE} --result ${RESULT_FILE} --output output --count 10
done