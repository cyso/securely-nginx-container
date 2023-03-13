#!/bin/sh
WATCH_DIR="$1/*"
WATCH_TMP_FILE="/tmp/rules"
INTERVAL=5

cat $WATCH_DIR > $WATCH_TMP_FILE; 
HASH=$(md5sum $WATCH_TMP_FILE)

# Sleep for startup
sleep $INTERVAL

while true
do
    cat $WATCH_DIR > $WATCH_TMP_FILE; 
    NEW_HASH=$(md5sum $WATCH_TMP_FILE)
    if [ "$HASH" != "$NEW_HASH" ]
    then
        echo "File $1 changed: Reloading Nginx"
        nginx -t && nginx -s reload
    fi

    HASH="$NEW_HASH"
    sleep $INTERVAL
done
