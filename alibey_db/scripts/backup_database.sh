#!/bin/bash
NOW=$(date +"%Y-%m-%d-%H%M")
PGPASSWORD="${SQL_PASSWORD}" pg_dump -U ${SQL_USER} -Fc ${SQL_DATABASE} > /backup/alibey-$NOW.dmp
