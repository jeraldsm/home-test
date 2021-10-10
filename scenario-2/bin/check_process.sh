#!/usr/bin/env bash

DATE=$(date +%m%d%y)
TIME=$(date +%H%M)
PROCESS=${1:-nginx}
RECIPIENT=${2:-jeraldsabu@gmail.com}

PID=$(ps -ef | grep ${PROCESS} | grep -v grep)
if [ "${PID}" = "" ]
   then
	echo "The process $PROCESS is down at $TIME on $DATE" | mail -s "Critical! Process $PROCESS  is down" $RECIPIENT > /dev/null 2>&1
else
	echo "The process $PROCESS is running."
fi
