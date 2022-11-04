#!/bin/sh

module load prun
source ./configure_env.sh

NUM_NODES=9
RESERVE_TIME=01:00:00
NODE_IP_PREFIX=10.149
TEAM_NAME=ddps2224
PROJECT_DIR="~/projects/ddps-asg1"

### Reserve nodes
reservationID=$(preserve -# $NUM_NODES -t $RESERVE_TIME | grep "Reservation number" | grep -Eo '[0-9]{1,10}')
echo ${reservationID}


### Create list of node IPs
nodeList="-"
while [ "$nodeList" == "-" ] || [ "$nodeList" == "" ]; do
	echo "Waiting for reservation..."
	sleep 5
	nodeList=$(preserve -llist | grep ${reservationID} | cut -f 9-)
done
echo "Got reservation!"

for node in $nodeList; do
	nodeNum=${node:4} #Strip the characters 'node'
	temp=${nodeNum::1} #Store the first of the three numbers
	nodeNum=${nodeNum:1:2} #Strip the first of the three numbers
	if [[ ${nodeNum::1} == 0 ]]; then #strip second number if it is zero
		nodeNum=${nodeNum:1}
	fi
	nodeIPList+=(${NODE_IP_PREFIX}.${temp}.${nodeNum}) #Append IP to list
done


### Get speial node IPs
nameNodeIP=${nodeIPList[0]}


### Update configs with special node IPs
sed -i "/<name>fs.defaultFS<\/name>/!b;n;c<value>hdfs:\/\/${nameNodeIP}:8020<\/value>" ${HADOOP_HOME}/etc/hadoop/core-site.xml
sed -i "/<name>yarn.resourcemanager.hostname<\/name>/!b;n;c<value>${nameNodeIP}<\/value>" ${HADOOP_HOME}/etc/hadoop/yarn-site.xml


### Populate Hadoop worker file
> ${HADOOP_HOME}/etc/hadoop/workers #Clear Hadoop worker file
echo "Got nodes: ${nodeIPList[@]}"
for ip in ${nodeIPList[@]:1}; do
	echo "${ip}" >> ${HADOOP_HOME}/etc/hadoop/workers
done

### Set up Spark config files
#sed -i "/SPARK_MASTER_HOST=.*/SPARK_MASTER_HOST=${sparkMasterIP}/; t; s/^/#SPARK_MASTER_HOST=${sparkMasterIP}/" ${SPARK_HOME}/conf/spark-env.sh

sed -i "s/SPARK_MASTER_HOST=.*/SPARK_MASTER_HOST=${nameNodeIP}/" ${SPARK_HOME}/conf/spark-env.sh

### Populate Spark worker file
 > ${SPARK_HOME}/conf/workers
for ip in ${nodeIPList[@]:1}; do
	echo "${ip}" >> ${SPARK_HOME}/conf/workers
done


### Execute startup script
echo "debut"
echo "### STARTING HADOOP THROUGH MASTER ###"
ssh ${TEAM_NAME}@${nameNodeIP} "${PROJECT_DIR}/start_hadoop.sh"
echo "### STARTING SPARK THROUGH MASTER ###"
ssh ${TEAM_NAME}@${nameNodeIP} "${PROJECT_DIR}/start_spark.sh"
echo "fin"

echo "Configured cluster with master node at IP ${nameNodeIP}"