#!/bin/sh

# Set default values if not set
set -a
: ${GRPC_URL?RPC URL required}
: ${USERNAME?Username required}
: ${PASSWORD?Password required}

if [ $BLOCKER_TLS = "1" ]
then 
   TLS="-tls"
fi
set +a

/usr/local/bin/securely-blocker -file /etc/securely-blocker-db -file_post_command 'nginx -t && nginx -s reload' &
