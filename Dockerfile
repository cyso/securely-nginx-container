FROM alpine
RUN apk add curl
RUN curl -L -o securely-blocker.zip 'https://git.securely.ai/securely/common/blocker/-/jobs/artifacts/master/download?job=compile' && \
    unzip securely-blocker.zip && \
    rm securely-blocker.zip

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.9.1-linux-x86_64.tar.gz

FROM owasp/modsecurity-crs:3.3.4-nginx-alpine-202211240811

RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
COPY --from=0 securely-blocker /usr/local/bin
RUN touch /etc/securely-blocker-db 

COPY docker-entrypoint.sh /docker-entrypoint.d/1000-securely-entrypoint.sh
COPY modsecurity-securely-blocker.conf /opt/owasp-crs/rules