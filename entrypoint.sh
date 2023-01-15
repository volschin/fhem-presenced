#!/bin/bash
# start services
sudo service dbus start
sudo service bluetooth start

# wait for startup of services
msg="Waiting for services to start..."
time=0
echo -n $msg
while [[ "$(pidof start-stop-daemon)" != "" ]]; do
    sleep 10
    time=$((time + 1))
    echo -en "\r$msg $time s"
done
echo -e "\r$msg done! (in $time s)"

# reset bluetooth adapter by restarting it
sudo hciconfig hci0 down
sudo hciconfig hci0 up

# start application
echo "Starte FHEM presenced"
rm -f /run/presenced.pid
exec /usr/bin/perl /presenced -v -p 5111
