FROM postgis/postgis:17-3.5

RUN mkdir -p /tmp/psql_data/
WORKDIR /tmp/psql_data/
COPY scripts/*.sql scripts/*.dmp /tmp/psql_data/
COPY scripts/init_database.sh /docker-entrypoint-initdb.d/
COPY scripts/backup_database.sh /usr/local/bin/
COPY scripts/restore_database.sh /usr/local/bin/