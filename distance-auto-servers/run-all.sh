#!/bin/bash
docker_distance=docker-distance-server

echo $(dirname "$0")

for server_root in $(dirname "$0")/servers/*/; do
	bash $docker_distance/run.sh $server_root "--restart unless-stopped"
done