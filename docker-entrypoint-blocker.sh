#!/bin/sh
touch /opt/securely/blocker-db
mkdir /opt/securely/secruleconfigurator
chmod -R 666 /opt/securely

/usr/local/bin/reload-nginx-blocker.sh /opt/securely/blocker-db &
/usr/local/bin/reload-nginx-secruleconfigurator.sh /opt/securely/secruleconfigurator &
/usr/local/bin/truncate-logs.sh &
