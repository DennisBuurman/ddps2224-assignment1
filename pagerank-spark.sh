#!/bin/sh
# Usage: ./pagerank-spark.sh <NameNodeIP>
source ./configure_env.sh

masterIP=$1
sparkPort=7077
hdfsPort=8020
INPUT_FILE="medium.txt"
RESULT_FILE="/home/ddps2224/pagerank-spark-result.txt"
NUM_REPETITIONS=10

# Remove result file
rm ${RESULT_FILE}

# Add files to HDFS
hadoop fs -mkdir -p /user/ddps2224
hadoop fs -rm spark-pagerank.jar
#hadoop fs -rm ${INPUT_FILE}
hadoop fs -put  bin/spark-pagerank.jar
hadoop fs -put /var/scratch/ddps2224/datasets/${INPUT_FILE}

# Add job to Spark
# spark-submit --class RunPageRank --master spark://${masterIP}:${sparkPort} --deploy-mode cluster hdfs://${masterIP}:${hdfsPort}/user/ddps2224/spark-pagerank.jar google.txt /home/ddps2224/spark_pagerank_out.txt 9
for i in $(seq 1 ${NUM_REPETITIONS})
do 
	spark-submit --class RunPageRank --deploy-mode client --executor-cores 8 --num-executors 8 --executor-memory 16G --master yarn hdfs://${masterIP}:${hdfsPort}/user/ddps2224/spark-pagerank.jar ${INPUT_FILE} ${RESULT_FILE} 10
	echo "Current iteration: $i"
done