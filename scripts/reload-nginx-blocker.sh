#!/bin/sh
WATCH_FILE="$1"
HASH=$(md5sum $WATCH_FILE)
INTERVAL=5

# Sleep for startup
sleep $INTERVAL

while true
do
    NEW_HASH=$(md5sum $WATCH_FILE)
    if [ "$HASH" != "$NEW_HASH" ]
    then
        echo "File $1 changed: Reloading Nginx"
        nginx -t && nginx -s reload
    fi

    HASH="$NEW_HASH"
    sleep $INTERVAL
done
