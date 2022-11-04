#!/bin/sh

# Config values
NUM_WORKERS=12
NUM_REPETITIONS=10
NUM_ITERATIONS=10
INPUT_FILE="large.txt"
RESULT_FILE="/home/ddps2224/pagerank-rdd-result.txt"

# Remove old result file
rm ${RESULT_FILE}

# Move files into HDFS
hadoop fs -mkdir -p /user/ddps2224
#hadoop fs -rm ${INPUT_FILE}
hadoop fs -put /var/scratch/ddps2224/datasets/${INPUT_FILE}


for i in $(seq 1 ${NUM_REPETITIONS})
do
	spark-submit  --conf spark.yarn.submit.waitAppCompletion=true --master yarn --deploy-mode client pagerank-rdd.py ${INPUT_FILE} ${NUM_ITERATIONS} ${RESULT_FILE}
	echo "Current iteration: $i"
done