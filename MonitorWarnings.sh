#!/bin/bash
#Import Settings
source /monitor/config.cfg

echo $(date +'%Y-%m-%d %T' -d "$ALARM_TRIGGER seconds ago")