#!/bin/bash
export MSYS_NO_PATHCONV=1;

export PUBLIC_IP=$(curl -s http://whatismyip.akamai.com/)
export SERVER_DIR=$1
export SCRIPT_DIR=$(dirname "$0")

bash $SCRIPT_DIR/stop.sh "$1";

BASE_PORT=`cat $SERVER_DIR/port.txt`
CONTAINER_NAME=distance-$BASE_PORT

PORT_SSH=$BASE_PORT
PORT_DISTANCE=$(($BASE_PORT + 1))
PORT_HTTP=$(($BASE_PORT + 2))

echo "Configuring and running distance server for $BASE_PORT"
echo "* SERVER DIR:     $1"
echo "* CONTAINER NAME: $CONTAINER_NAME"
echo "* NETWORK NAME:   $CONTAINER_NAME"
echo "* IP:             $PUBLIC_IP"
echo "* SSH PORT:       $PORT_SSH"
echo "* DISTANCE PORT:  $PORT_DISTANCE"
echo "* HTTP PORT:      $PORT_HTTP"
echo "* EXTRA ARGS:     $2"

if [[ $(uname) == MINGW* ]] || [[ $(uname) == CYGWIN* ]];
then
	echo "* HOST OS:        WINDOWS"
	HOST_ARGS=""
elif [[ $(uname) == Linux ]];
then
	echo "* HOST OS:        LINUX"
	HOST_ARGS="--net=host"
	sudo ufw allow $PORT_DISTANCE
	sudo ufw allow $PORT_HTTP
elif [[ $(uname) == Darwin ]];
then
	echo "* HOST OS:        MAC"
	HOST_ARGS=""
else
	echo "* HOST OS:        UNKNOWN"
	HOST_ARGS=""
fi

docker run -d \
	-p $PORT_SSH:$PORT_SSH \
	-p $PORT_DISTANCE:$PORT_DISTANCE \
	-p $PORT_HTTP:$PORT_HTTP \
	--mount type=bind,source="$(realpath $SERVER_DIR/config/)",target="/root/distance-server/config-base/",readonly \
	--mount type=bind,source="$(realpath $SCRIPT_DIR/Distance.dll)",target="/root/distance-server/bin/Distance.dll",readonly \
	--env PUBLIC_IP=$PUBLIC_IP --env PORT_SSH=$PORT_SSH --env PORT_DISTANCE=$PORT_DISTANCE --env PORT_HTTP=$PORT_HTTP \
	--cap-add=NET_ADMIN --cap-add=SYS_PTRACE \
	-p 10000-65535 \
	$HOST_ARGS \
	$2 \
	--name $CONTAINER_NAME \
	corecii/distance-server