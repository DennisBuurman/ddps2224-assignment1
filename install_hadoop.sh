#!/bin/sh

SCRATCH_DIR="/var/scratch/ddps2224"
HADOOP_ARCHIVE="hadoop-3.3.4.tar.gz"
HADOOP_DIR="hadoop-3.3.4"
CONFIG_DIR="/var/scratch/ddps2224/hadoop/etc/hadoop"

# Download & unzip Hadoop
wget https://dlcdn.apache.org/hadoop/common/current/hadoop-3.3.4.tar.gz
mkdir -p $SCRATCH_DIR
rm -rf "${SCRATCH_DIR}/hadoop"
tar -xf "${HADOOP_ARCHIVE}" --directory ${SCRATCH_DIR}
mv "${SCRATCH_DIR}/${HADOOP_DIR}" "${SCRATCH_DIR}/hadoop"
rm "${HADOOP_ARCHIVE}"

# Configure Hadoop by overwriting with our configs
cp configs/hadoop/* ${CONFIG_DIR}/