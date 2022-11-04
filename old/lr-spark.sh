#!/bin/sh

source ./configure_env.sh

masterIP=$1
sparkPort=7077
hdfsPort=8020

# Add files to HDFS
hadoop fs -mkdir -p /user/ddps2224
hadoop fs -rm sample_svm_data.txt
hadoop fs -put /var/scratch/ddps2224/datasets/sample_svm_data.txt

# Add job to Spark
spark-submit --master spark://${masterIP}:${sparkPort} --deploy-mode client logistic_regression.py /user/ddps2224/sample_svm_data.txt 10