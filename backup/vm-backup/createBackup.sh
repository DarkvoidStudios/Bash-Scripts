#!/bin/bash
#Import Settings
source config.cfg

mkdir ${PROJECT_PATH}/logs -p

# Get amount of all virtual mashines, with the id not bigger than 10900.
# Due to the template virtual machines all id's below 10900 are not
# considered, because templates do not need to be extra saved.
qm list | awk '{if($1<10900)print$1}' | grep -o '[0-9]\+' | while read line; do
    echo "${C_GREEN}Starting backup for VMID: ${line}${C_RESET}"
    vzdump ${line} --mode snapshot --compress zstd --pigz 1 --zstd 2 --bwlimit ${BWLIMIT} | tee ${PROJECT_PATH}/logs/latest.log
done
exit