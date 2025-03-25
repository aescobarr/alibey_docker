#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: geoserver docker name required"
    echo "Usage: $0 <your_parameter>"
    exit 1
fi

GEOSERVER_DOCKER_NAME=$1

docker exec -it $GEOSERVER_DOCKER_NAME /usr/local/bin/backup_geoserver.sh