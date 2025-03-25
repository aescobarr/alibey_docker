#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: database docker name required"
    echo "Usage: $0 <your_parameter>"
    exit 1
fi

DATABASE_DOCKER_NAME=$1

echo "Backing up database...."
docker exec -it $DATABASE_DOCKER_NAME /usr/local/bin/backup_database.sh
echo "Done!"