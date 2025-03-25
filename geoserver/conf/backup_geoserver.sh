#!/bin/bash
NOW=$(date +"%Y-%m-%d-%H%M")
tar zcvf /backup/$NOW-geoserver-data-dir.tar.gz ${GEOSERVER_DATA_DIR}