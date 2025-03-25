FROM docker.osgeo.org/geoserver:2.26.2

COPY conf/web.xml /tmp/web.xml
COPY conf/context.xml /tmp/context.xml
COPY conf/datastore.xml /tmp/datastore.xml
COPY conf/backup_geoserver.sh /usr/local/bin/
COPY entrypoint.sh /tmp/entrypoint.sh 

RUN chmod +x /tmp/entrypoint.sh

## Iniciar tomcat
ENTRYPOINT ["/tmp/entrypoint.sh"]