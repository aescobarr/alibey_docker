#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: web docker name required"
    echo "Usage: $0 <your_parameter>"
    exit 1
fi

WEB_DOCKER_NAME=$1

docker exec -it $1 python3 /public_html/scripts/toponims_api.py
docker exec -it $1 python3 /public_html/scripts/toponimsversio_api.py
docker exec -it $1 python3 /public_html/scripts/geometries_api.py