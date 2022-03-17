#!/bin/bash
#Import Settings
source /monitor/config.cfg

#CPU
#cpu_usage_per_core=($(mpstat -P ALL 1 1 | awk '/Average:/ && $2 ~ /[0-9]/ {print $3}'))

#Has to be declared first
#Function to send data to the database
sendDataToDatabase () {
	mysql --user=$DB_USER --password=$DB_PASSWORD $DB_NAME <<EOF
	INSERT INTO $DB_TBL_today (\`cpu_usage\`, \`memory_usage\`, \`drive_usage\`, \`traffic\`) VALUES ('$1', '$2', '$3', '$4');
EOF
}

while true; do
	sleep $UPDATE_TIME
	#Create temp directory if not exists
	mkdir -p ${PROJECT_FOLDER}/temp/
	mkdir -p ${PROJECT_FOLDER}/logs/
	
	#Create cpu usage temp file 
	ps -A -o pcpu | tail -n+2 | paste -sd+ | bc > ${PROJECT_FOLDER}/temp/temp_cpu.log

	#Get all CPU usages & and it into file
	file=`cat ${PROJECT_FOLDER}/temp/temp_cpu.log`

	#Calculate CPU average & and it into file
	echo "scale=2;$file / $CPU_AMOUNT" | bc > ${PROJECT_FOLDER}/temp/temp_cpu.log

	#Get CPU average from file and save it in variable
	cpu_usage=`cat ${PROJECT_FOLDER}/temp/temp_cpu.log`

	#Memory
	memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
	memory_temp=1

	#Harddrives
	drive_usage=$(df -hP / | awk '{print $5}' |tail -1|sed 's/%$//g')
	drive_temp=1

	#Networktraffic
	traffic=1

	#Insert data to database
	sendDataToDatabase "$cpu_usage" "$memory_usage" "$drive_usage" "$traffic"

	#Get current time
	time=$(date "+%T")
	date=$(date +'%d.%m.%Y')
	
	#Save data to log
	echo -e "[$date $time] CPU:$cpu_usage MEM:$memory_usage HardDrive:$drive_usage Traffic:$traffic" >> ${PROJECT_FOLDER}/logs/$date.log
	
	echo "${C_GREEN}Send data to server at: ${C_RESET}$time" 
	wait;
done