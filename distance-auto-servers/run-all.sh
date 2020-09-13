#!/bin/bash
docker_distance=docker-distance-server

echo $(dirname "$0")

bash $(dirname "$0")/stop-all.sh

node $(dirname "$0")/service-runner $(dirname "$0")/server/DistanceServer.x86_64 $(dirname "$0")/servers </dev/null >$(dirname "$0")/service-runner.log 2>&1 &
disown

echo "$!" > $(dirname "$0")/service-runner-pid