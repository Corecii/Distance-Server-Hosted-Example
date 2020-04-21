#!/bin/bash
export SERVER_DIR=$1 #$(dirname "$0")

BASE_PORT=`cat $SERVER_DIR/port.txt`
CONTAINER_NAME=distance-$BASE_PORT

PORT_SSH=$BASE_PORT
PORT_DISTANCE=$(($BASE_PORT + 1))
PORT_HTTP=$(($BASE_PORT + 2))

if [[ $(uname) == Linux ]];
then
	sudo ufw delete allow $PORT_DISTANCE
	sudo ufw delete allow $PORT_HTTP
fi

docker container kill $CONTAINER_NAME;
docker container rm $CONTAINER_NAME;