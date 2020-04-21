export MSYS_NO_PATHCONV=1;

export SERVER_DIR=$1 #$PWD/$(dirname "$0")
BASE_PORT=`cat $SERVER_DIR/port.txt`
CONTAINER_NAME=distance-$BASE_PORT

docker container exec $CONTAINER_NAME cat /root/distance-server/Server.log