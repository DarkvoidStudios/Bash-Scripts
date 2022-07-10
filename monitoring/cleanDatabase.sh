#!/bin/bash
#Import Settings
source /monitor/config.cfg

#Removes all database entries older than 1 day
cleanDatabase () {
	mysql --user=$DB_USER --password=$DB_PASSWORD $DB_NAME <<EOF
	TRUNCATE log_today;
EOF
}

cleanDatabase
echo "${C_GREEN}The database was cleaned up${C_RESET}"