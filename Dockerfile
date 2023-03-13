FROM owasp/modsecurity-crs:3.3.4-nginx-alpine-202211240811

RUN mkdir -p /opt/securely
    
COPY scripts/docker-entrypoint.sh /docker-entrypoint.d/1000-securely-entrypoint.sh
COPY scripts/reload-nginx-blocker.sh /usr/local/bin
COPY scripts/reload-nginx-secruleconfigurator.sh /usr/local/bin
COPY scripts/truncate-logs.sh /usr/local/bin
COPY conf/modsecurity-securely-blocker.conf /opt/owasp-crs/rules/0000-modsecurity-securely-blocker.conf
COPY conf/modsecurity-securely-secruleconfigurator.conf /opt/owasp-crs/rules/0000-modsecurity-securely-secruleconfigurator.conf