FROM owasp/modsecurity-crs:3.3.4-nginx-alpine-202211240811

RUN mkdir /opt/securely
    
COPY docker-entrypoint-blocker.sh /docker-entrypoint.d/1000-securely-entrypoint-blocker.sh
COPY reload-nginx-blocker.sh /usr/local/bin
COPY truncate-logs.sh /usr/local/bin
COPY modsecurity-securely-blocker.conf /opt/owasp-crs/rules