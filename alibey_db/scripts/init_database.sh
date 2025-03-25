#!/bin/bash

APP_DATABASE_NAME=${SQL_DATABASE}
DATABASE_USER=${SQL_USER}
DATABASE_USER_PASSWORD=${SQL_PASSWORD}
DB_DUMP_LOCATION='/tmp/psql_data/alibey.dmp'
DB_INIT_DATA_LOCATION='/tmp/psql_data/alibey_init_data.sql'
DB_INIT_SCHEMA_LOCATION='/tmp/psql_data/alibey_schema.sql'

psql postgres -c "CREATE ROLE $DATABASE_USER LOGIN PASSWORD '$DATABASE_USER_PASSWORD' SUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION;"
createdb $APP_DATABASE_NAME -O $DATABASE_USER

# if there is a dump, restore dump
if [ -f "$DB_DUMP_LOCATION" ]; then
    pg_restore -j 4 -v -d $APP_DATABASE_NAME $DB_DUMP_LOCATION
else # else, restore blank database + init data
    psql -d $APP_DATABASE_NAME -f "$DB_INIT_SCHEMA_LOCATION"
    psql -d $APP_DATABASE_NAME -f "$DB_INIT_DATA_LOCATION"
fi


