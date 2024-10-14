#!/bin/sh

GEO_IP_DB_PATH=/usr/local/share/GeoIP

if [ -f "$GEO_IP_DB_PATH/GeoLite2-City.mmdb" ]; then
  # If GeoLite2-City database exists, use it

  ARGS="\
      --agent-list \
      --log-file=/usr/local/goaccess/logs/access.log \
      --log-format=COMBINED \
      --real-time-html \
      --output=/usr/local/goaccess/html/index.html \
      --geoip-database=$GEO_IP_DB_PATH/GeoLite2-City.mmdb \
      --persist \
      --db-path=/usr/local/goaccess/db/ \
      --restore"
else
  # If GeoLite2-City database doesn't exist, don't use it

  ARGS="\
      --agent-list \
      --log-file=/usr/local/goaccess/logs/access.log \
      --log-format=COMBINED \
      --real-time-html \
      --output=/usr/local/goaccess/html/index.html \
      --persist \
      --db-path=/usr/local/goaccess/db/ \
      --restore"
fi

# shellcheck disable=SC2086
/bin/goaccess $ARGS
