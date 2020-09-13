#!/bin/bash
docker_distance=docker-distance-server

echo $(dirname "$0")

if [ -e $(dirname "$0")/service-runner-pid ]
then
	servicepid=`cat $(dirname "$0")/service-runner-pid`
	rm $(dirname "$0")/service-runner-pid
	PGID=$(ps -o pgid= $servicepid | grep -o [0-9]*)
	echo "PGID IS $PGID"
	kill -TERM -"$PGID"
	sleep 2
	kill -KILL -"$PGID"
fi