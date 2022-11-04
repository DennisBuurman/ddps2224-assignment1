#!/bin/sh

SCRATCH_DIR="/var/scratch/ddps2224"
SPARK_ARCHIVE="spark-3.3.0-bin-without-hadoop.tgz"
SPARK_DIR="spark-3.3.0-bin-without-hadoop"
CONFIG_DIR="/var/scratch/ddps2224/spark/conf"

# Download & unzip Apache Spark
wget https://archive.apache.org/dist/spark/spark-3.3.0/spark-3.3.0-bin-without-hadoop.tgz
mkdir -p $SCRATCH_DIR
rm -rf "${SCRATCH_DIR}/spark"
tar -xf "${SPARK_ARCHIVE}" --directory ${SCRATCH_DIR}
mv "${SCRATCH_DIR}/${SPARK_DIR}" "${SCRATCH_DIR}/spark"
rm "${SPARK_ARCHIVE}"

# Configure Hadoop by overwriting with our configs
cp configs/spark/* ${CONFIG_DIR}/