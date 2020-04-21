#!/bin/bash
export SCRIPT_DIR=$(dirname "$0")

docker build -t corecii/distance-server $SCRIPT_DIR