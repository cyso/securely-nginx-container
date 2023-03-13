#!/bin/sh
INTERVAL=300

# Sleep for startup
sleep $INTERVAL

while true
do
    echo "Truncating logs /opt/securely/*.log"
    truncate -s 0 /opt/securely/*.log
    sleep $INTERVAL
done
