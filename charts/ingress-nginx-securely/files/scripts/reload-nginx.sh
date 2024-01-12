#/bin/sh
while true
do
  pgrep "nginx: master" > /dev/null 2>&1
  exit_status=$?
  if [ $exit_status -eq 0 ]
  then
    echo "Nginx process found, continuing script"
    break
  else
    echo "Nginx process not found, sleeping for 5 seconds"
    sleep 5
  fi
done
echo "Nginx process found, continuing script"

echo "Running nginx config test"
nginx -t 
exit_status=$?

if [ $exit_status -ne 0 ]
then
  echo "Nginx configtest failed"
  killall /app
  exit 1
fi

NGINX_PID=$(pgrep "nginx: master")

echo "Reloading NGINX, PID: $NGINX_PID"
kill -HUP $NGINX_PID