#!/bin/sh

PROJECT_DIR="/home/ddps2224/projects/ddps-asg1"
source "${PROJECT_DIR}/configure_env.sh"

NAMENODE_DIR="/local/ddps2224/namenode_data"
DATANODE_DIR="/local/ddps2224/datanode_data"

# Delete old data
${HADOOP_HOME}/sbin/workers.sh rm -rf ${DATANODE_DIR}
${HADOOP_HOME}/sbin/workers.sh rm -rf ${NAMENODE_DIR}

# Make space for new data
${HADOOP_HOME}/sbin/workers.sh mkdir -p $DATANODE_DIR

# Start HDFS cluster
echo "Formatting cluster"
echo "Y" | ${HADOOP_HOME}/bin/hdfs namenode -format >> /dev/null
${HADOOP_HOME}/sbin/start-dfs.sh
${HADOOP_HOME}/sbin/start-yarn.sh
${HADOOP_HOME}/bin/mapred --daemon start historyserver