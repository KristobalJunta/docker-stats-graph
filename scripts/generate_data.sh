#!/usr/bin/env bash

if [ -z "$2" ]; then
    mins="30"
else
    mins="$2"
fi

echo "Collecting stats for $1 during $mins minutes"

# Using linux date
# For mac - brew install coreutils ; echo "alias date=gdate" >> ~/.bash_profile
runtime="$mins minutes"
endtime=$(date -ud "$runtime" +%s)

# clear data
true > data.csv

# while true
while [[ $(date -u +%s) -le ${endtime} ]]
do docker stats "$1" --no-stream\
    --format "table {{.Name}};{{.CPUPerc}};{{.MemPerc}};{{.MemUsage}};{{.NetIO}};{{.BlockIO}};{{.PIDs}}" > dockerstats
tail -n +2 dockerstats | awk -v date=";$(date +%T)" '{print $0, date}' >> data.csv
sleep 5
done

cat data.csv
rm -rf dockerstats
