#!/bin/bash
su - postgres -c "dropdb ${SQL_DATABASE}"
su - postgres -c "createdb ${SQL_DATABASE} -O ${SQL_USER}"

PGPASSWORD="${SQL_PASSWORD}" pg_restore -U ${SQL_USER} -d ${SQL_DATABASE} --clean --if-exists -Fc /backup/$1

