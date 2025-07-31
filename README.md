# Ali-Bey

Ali-Bey is a web application for georeferencing site names, originally created for the Museu de Ciencies Naturals de Barcelona - [MCNB](https://museuciencies.cat/). It allows the storage, indexing and querying of georeferenced site names, including their geometry, and supports multiple versions of the site names. Ali-Bey is built using [Django Python web framework](https://www.djangoproject.com/).

This application was originally written as two separate projects: 
1. [mcnb-alibey](https://github.com/aescobarr/mcnb-alibey) - The main django app
1. [mcnb-alibey-api](https://github.com/aescobarr/mcnb-alibey-api) - The API

Both these projects have been merged in the present dockerized app, and should be considered **deprecated**.

## Application structure

The app is composed of several services (see the docker-compose.yml file). If we maintain the docker service names, these are:
1. web - the django web app. 
1. db - the postgresql database.
1. geoserver - a Geoserver instance which supplies most of the Web Map Service capabilities
1. api - the nodejs API

## Getting started

You need a working [Docker](https://www.docker.com/) setup. To create a working development environment you need to follow these steps:

### Create an .env file

Create and adjust the .env file. We supply an env-example file which can be used as template
```
# create a copy of the template file
cp env-example .env
```
Then edit the recently created .env file to suit your needs. This is the list of parameters, including a brief comment on their function:
```
# This key tells django to run in debug mode (1) or not (0)
# Don't run django with DEBUG=1 in production environments!
DEBUG=False
# Long, complicated string that django uses internally for things like identifying sessions. Keep it unique.
SECRET_KEY=foo
# Hosts which will be allowed to connect to Django
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1 [::1]

# List of allowed domains for unsafe requests. This maps directly to the Django 
# setting value CSRF_TRUSTED_ORIGINS (https://docs.djangoproject.com/en/5.2/ref/settings/#csrf-trusted-origins)
# Can be multiple sites, separated by spaces
DJANGO_CSRF_TRUSTED_ORIGINS=https://example.com

# Admin user credentials. This user will be created when the container is initialized and you will 
# be able to use it for administrative purposes
DJANGO_ADMIN_USER=alibey_admin
DJANGO_ADMIN_PASSWORD=XXXXXXXXXXX
DJANGO_ADMIN_EMAIL=alibey_admin@alibey.org

# Regular user credentials. This user also is created when the container is initialized.
DJANGO_REGULAR_USER=alibey_regular
DJANGO_REGULAR_PASSWORD=YYYYYYYYYY
DJANGO_REGULAR_EMAIL=alibey_regular@alibey.org

# Django database engine. Do not change this value
SQL_ENGINE=django.contrib.gis.db.backends.postgis
# Name of the app database
SQL_DATABASE=djangoref
# Name of the app database owner user (postgres user)
SQL_USER=aplicacio_georef
# The password of the database owner user
SQL_PASSWORD=ZZZZZZZZZZ
# DB host address. Do not change this value.
SQL_HOST=db
# Database running port
SQL_PORT=5432

# Tomcat admin user
TOMCAT_USER=admintom
# Tomcat admin password
TOMCAT_PASSWORD=TTTTTTTTTTTT
# Tomcat home
TOMCAT_DIR=/usr/local/tomcat
# Geoserver data dir
GEOSERVER_DATA_DIR=/opt/geoserver/data_dir
# Geoserver admin user name
GEOSERVER_ADMIN_USER=some_admin_user
# Geoserver admin user password
GEOSERVER_ADMIN_PASSWORD=123456789abc
# Bing maps API key. If you don't have one, Bing Maps will not work
BING_MAPS_API_KEY='my_bings_api_key'

# API Stuff
# Whether the app runs in development mode or not. Affects stuff like logging
NODE_ENV="development"
# API running port
RUNNING_PORT=7000
# Log level
LOG_LEVEL="info"
# If this key is present, rate limit for the API is disabled
DISABLE_RATE_LIMIT="true"
```
### Database setup

When starting for the first time, the database service checks for a file called /alibey_db/scripts/alibey.dmp. If this file does exist, and is a backup of a valid Ali-Bey instance, the instance initializes the database with a restored version of this backup.

If this file does not exist, the database is initialized in a basic operating state:
- The database schema is created
- Two users are created: the ones defined in the .env file as DJANGO_REGULAR_USER and DJANGO_ADMIN_USER
- The bare minimum data for the app to operate is also created: a default organization and the "World" site

### Running the app

There is a Makefile provided which contains a set of predefined instructions to run and build the containers. This Makefile uses [GNU Make](https://www.gnu.org/software/make/manual/make.html). This is entirely optional and used for convenience, but any usual docker command still works.

To invoke a Makefile target, the syntax is:
```
make [target name]
```
If we call ```make``` without arguments, we obtain a list of the available targets:
```
Running with env value DEV
build                          Build containers.
clean_docker                   Remove all container and images.
down                           Stop all containers.
logs                           Show all containers logs.
ps                             List containers.
restart                        Restart service containers.
start                          Create and start containers.
start_u                        Create and start containers without detached mode
stop                           Stop all containers.
```
The Makefile can run in development or production mode. By default, it runs in development mode. To use production mode, we call make like this:
```
ENV=PROD make [target name]
```
Production mode uses the docker-compose.yml file, while development uses docker-compose-debug.yml. The main differences between the modes are that production does not provide a web server. This container is supposed to run behind a production-ready web server (Apache or Nginx) which acts as a reverse proxy. Development on the other hand has an additional service 'nginx' which serves the app locally.

It's easy to replicate the non-make version of any command in the Makefile. For instance, to build the containers in development mode, we would issue the command
```
docker compose -f docker-compose-debug.yml build
```
We simply use the ```-f```option to specify the name of the compose file (docker-compose-debug-yml for development, docker-compose.yml for production).

### Development mode considerations

We recommend using [Visual Studio Code](https://code.visualstudio.com/) for development. We would start the docker for development with the command
```
make start
```
or the non-makefile version
```
docker compose -f docker-compose-debug.yml up -d --force-recreate
```
To see the containers output, we can use
```
make logs
```
or the non-makefile version
```
docker compose -f docker-compose-debug.yml logs -f
```
The debug version allows the live debugging of the web service (the Django project, which is in the folder /mcnb-alibey). To set up this, we need to create a launch.json file for Visual Studio.
The launch.json file looks like this:
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python Debugger: Remote Attach",
            "type": "debugpy",
            "request": "attach",
            "connect": {
                "host": "localhost",
                "port": 5678
            },
            "justMyCode": true, 
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}/mcnb-alibey",
                    "remoteRoot": "/public_html"
                }
            ]
        }
    ]
}
```
The development version starts a [debugpy](https://pypi.org/project/debugpy/) instance in port 5678, and waits for external connections. When we run the project via Visual Studio with the proposed launch.json file, the app will run in debug mode and we will be able to set up breakpoints and inspect variables.

### Running in production

In production, Ali-Bey is meant to run behind a production web server (Nginx or Ali-Bey) running as a reverse proxy. By default, the web app spawns a gunicorn server in port 49155. 

### Programmed tasks

In a production environment, we need to set up a few programmed tasks for the app. Some of these are more or less optional but very recommended, and some are required for the app to work correctly.

The programmed tasks are available in the /util_scripts folder. The following are backup related and optional:

1. ***backup_database.sh*** - this script backs up the current database and dumps the backup in the folder alibey_db/backup. The file name has the format alibey-[YYYY]-[MM]-[DD]-[HHMM].dmp and is a Postgresql dump done with pg_dump -Fc.
1. ***restore_database.sh*** - this script restores one of the backups created with the backup script. The script is called like this:
    ```
    ./util_scripts/restore_database.sh [db_container_name] [backup_file_name]
    ```
    The db_container_name is the name of the database container, obtained via the command ```docker ps```. It's usually something like 'alibey_docker-db-1'. This script drops the current database and replaces it with the backup.
1. ***backup_geoserver.sh*** - this script backs up the GeoServer data directory and dumps it in the folder /geoserver/backup. The script is called like this:
    ```
    ./util_scripts/backup_geoserver.sh [geoserver_container_name]
    ```
    The file name has the format [YYYY]-[MM]-[DD]-[HHMM]-geoserver-data-dir.tar.gz. To restore the backup stop the docker compose services and replace the geoserver/data_dir folder with the /data_dir folder inside the exploded backup.

The remaining task is not optional, and should be executed regularly:
1. ***refresh_api_tables.sh*** - this script refreshes the API static tables. These tables contain denormalized site information, and every time it's executed the API data is updated with the latest site data.