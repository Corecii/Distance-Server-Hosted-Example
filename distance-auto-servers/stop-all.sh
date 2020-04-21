#!/bin/bash
$docker_distance=docker-distance-server

for server_root in servers; do
	bash $docker_distance/stop.sh server_root
done