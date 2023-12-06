#/bin/sh
NGINX_PID=$(pgrep "nginx: master")

echo "Reloading NGINX, PID: $PID"
kill -HUP $NGINX_PID