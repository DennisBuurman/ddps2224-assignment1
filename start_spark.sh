#!/bin/sh

PROJECT_DIR="/home/ddps2224/projects/ddps-asg1"
source "${PROJECT_DIR}/configure_env.sh"

# Start Spark cluster
echo "Starting master"
${SPARK_HOME}/sbin/start-master.sh
echo "Starting slaves"
${SPARK_HOME}/sbin/start-workers.sh
${SPARK_HOME}/sbin/start-history-server.sh