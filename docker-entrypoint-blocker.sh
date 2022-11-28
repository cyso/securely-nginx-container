#!/bin/sh
touch /opt/securely/blocker-db 
chmod 666 /opt/securely/blocker-db 
/usr/local/bin/reload-nginx-blocker.sh /opt/securely/blocker-db &
