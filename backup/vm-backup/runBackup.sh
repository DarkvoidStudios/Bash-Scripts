#!/bin/bash
#Import Settings
source config.cfg

#Check if screen monitor screen exists
if screen -list | grep -q "$SCREEN_NAME"; then
        #Screen already exists
        echo "${C_RED}Backup already running${C_RESET}"
        exit 1
else
        #Screen doesnt exists
        echo "${C_GREEN}Backup is starting${C_RESET}"
        echo "${C_YELLOW}Backup of ${VM_COUNT}/${VM_TOTAL_COUNT} virtual machines in total!${C_RESET}"
        rm ${LOG_FILE} -f
        screen -dmS $SCREEN_NAME

        screen -S $SCREEN_NAME -p 0 -X stuff "bash ${PROJECT_PATH}/createBackup.sh^M"
fi