#!/usr/bin/with-contenv bashio
set -e

DATABASE_PASSWORD=$(bashio::config 'database_password')
DATABASE_USERNAME=$(bashio::config 'database_username')
DATABASE_URL=$(bashio::config 'database_url')
HIBISCUS_PASSWORD=$(bashio::config 'hibiscus_password')

BASE_PATH="/home/hibiscus/hibiscus-server/cfg/"
CONFIG_FILE="$BASE_PATH/de.willuhn.jameica.hbci.rmi.HBCIDBService.properties"

sed -i -e "s|DATABASE_URL|${DATABASE_URL}|g" -e "s|DATABASE_USERNAME|${DATABASE_USERNAME}|g" -e "s|DATABASE_PASSWORD|${DATABASE_PASSWORD}|g" $CONFIG_FILE

/home/hibiscus/hibiscus-server/jameicaserver.sh -w $HIBISCUS_PASSWORD -f /data
#tail -f /dev/null
