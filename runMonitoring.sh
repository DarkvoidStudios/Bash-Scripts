#!/bin/bash
#Import Settings
source /monitor/config.cfg

#Create temp directory if not exists
mkdir -p ${PROJECT_FOLDER}/logs/

#DELETES ONLY .LOG FILES
#Deletes all log files older than specific time / Orients to the last modified
if [[ $(find ${PROJECT_FOLDER}/logs/*.log -mtime +$LOG_LIFE -print) ]]; then
	echo "${C_YELLOW}Removed files older than $(date +'%d.%m.%Y' -d "$LOG_LIFE day ago")${C_RESET}"
	find ${PROJECT_FOLDER}/logs/*.log -mtime +$LOG_LIFE -delete
fi

#Get current status of the monitoring programm in a boolean / checks if its running or not
IS_RUNNING=$(ps -ef | grep "MonitorDataCrawler.sh" | grep -v grep | wc -l | xargs)

#Check if screen monitor screen exists
if screen -list | grep -q "$SCREEN_NAME"; then
	#Screen already exists
	#Check if monitor programm is already running
	if [ "$IS_RUNNING" -eq "1" ]; then
		#Monitoring already running
		echo "${C_RED}Monitoring is already running${C_RESET}"
		exit 1
	else
		#Monitoring isnt running
		screen -S $SCREEN_NAME -p 0 -X stuff "bash /monitor/MonitorDataCrawler.sh^M"
		echo "${C_GREEN}Starting monitoring program${C_RESET}"
		exit 1
	fi
else
	#Screen doesnt exists
	screen -dmS $SCREEN_NAME
	if [ "$IS_RUNNING" -eq "1" ]; then
		#Monitoring already running
		echo "${C_RED}Monitoring is already running${C_RESET}"
		exit 1
	else
		#Monitoring isnt running
		screen -S $SCREEN_NAME -p 0 -X stuff "bash /monitor/MonitorDataCrawler.sh^M"
		echo "${C_GREEN}Starting monitoring program${C_RESET}"
		exit 1
	fi
fi