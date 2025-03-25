#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: database docker name required"
    echo "Usage: $0 <database-docker-name> <backup-file-name>"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Error: backup file name required"
    echo "Usage: $0 <database-docker-name> <backup-file-name>"
    exit 1
fi

DATABASE_DOCKER_NAME=$1

echo "Stopping web container"
docker stop alibey-web-1
echo "Stopping geoserver container"
docker stop $DATABASE_DOCKER_NAME

echo "Restoring database"
docker exec -it $DATABASE_DOCKER_NAME /usr/local/bin/restore_database.sh $2

echo "Starting web container"
docker start $DATABASE_DOCKER_NAME
echo "Starting geoserver container"
docker start $DATABASE_DOCKER_NAME