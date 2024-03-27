#!/bin/sh

maxsize=50000000 #50MB

file1='/opt/securely-logs/access.log'
file2='/opt/securely-logs/modsec_audit.log'

# Wait until both files exist
while [ ! -f $file1 ] || [ ! -f $file2 ]; do
    echo "Waiting for files to exist, they were not found"
    sleep 10
done

 echo "Files found, watching size"

while true; do
    # Loop over each file
    for file in $file1 $file2
    do
        # If the file size is greater than maxsize
        if [ $(stat -c%s "$file") -gt $maxsize ]; then
            : > $file
            echo "Truncated $file because it was too large."
        fi
    done

    # Wait for 10 seconds before checking again
    sleep 10
done