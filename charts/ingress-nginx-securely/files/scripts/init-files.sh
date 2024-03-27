#!/bin/sh
touch /opt/securely/blocker-db
mkdir /opt/securely/conf

# Set blocker modsec rule with IP database
echo 'SecRule REQUEST_HEADERS:X-Forwarded-for "@ipMatchFromFile /opt/securely/blocker-db" "id:300000,phase:1,t:none,log,auditlog,msg:'IP blocked due to Securely IP Blocking Service',deny,ctl:ruleEngine=On"' > /opt/securely/conf/blocker.conf 
echo 'SecRule REMOTE_ADDR "@ipMatchFromFile /opt/securely/blocker-db" "id:300100,phase:1,t:none,log,auditlog,msg:'IP blocked due to Securely IP Blocking Service',deny,ctl:ruleEngine=On"' >> /opt/securely/conf/blocker.conf 

chmod -R 777 /opt/securely
