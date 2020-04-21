#!/bin/bash
echo "Starting distance server"
echo "* IP:             $PUBLIC_IP"
echo "* SSH PORT:       $PORT_SSH"
echo "* DISTANCE PORT:  $PORT_DISTANCE"
echo "* HTTP PORT:      $PORT_HTTP"

echo "PORT $PORT_SSH" >> /etc/ssh/sshd_config
/usr/sbin/sshd -D &

mkdir /root/distance-server/config/
cp -rL /root/distance-server/config-base/*.* /root/distance-server/config/

for file in /root/distance-server/config/*.*; do
	sed -i "s/45670/$PORT_SSH/g" "$file"
	sed -i "s/45671/$PORT_DISTANCE/g" "$file"
	sed -i "s/45672/$PORT_HTTP/g" "$file"
done

if [[ $USE_DUMMY == true ]]; then
	ip link add eth1 type dummy
	ip addr add $PUBLIC_IP/24 brd + dev eth1
	ip link set eth1 up
fi

/root/distance-server/bin/DistanceServer.x86_64 -logFile /root/distance-server/Server.log -nodefaultplugins -serverDir /root/distance-server/config -masterserverworkaround -batchmode -nographics > /root/distance-server/base.log
