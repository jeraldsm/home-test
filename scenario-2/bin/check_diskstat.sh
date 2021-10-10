#!/usr/bin/env bash

# Original Author: Jerald Sabu Manakkunnel

MAILLIST=${1:-jeraldsabu@gmail.com}

# IOSTAT to gather I/O for 5x @ 2 seconds
iostat -x 2 5 | tee /tmp/iologfile.`date +%h%d%y`

date >> /tmp/iologfile.`date +%h%d%y`
cat /tmp/iologfile.`date +%h%d%y` | mail -s "DISK IO Output" ${MAILLIST}
