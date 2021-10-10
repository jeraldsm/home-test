#!/usr/bin/env bash

# This program prints random numbers from 1 to 10

MIN_COUNT=${1:-1}
MAX_COUNT=${2:-10}

for (( i=$MIN_COUNT;i<=$MAX_COUNT;i++ )) 
do 
	echo $RANDOM "$i"; 
done \
| sort -k1 |cut -d" " -f2

