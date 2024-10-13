#!/bin/sh

if [ -n "$MAXMIND_LICENSE_KEY" ]; then
  # Check if GEO_IP_DB_PATH is set
  if [ ! -f "$GEOIP_DB_PATH/GeoLite2-City.mmdb" ]; then
    echo "GeoLite2 database not found. Exiting..."
    exit 1
  fi

  ARGS="--log-file=/usr/local/goaccess/logs/access.log" \
    "--log-format=COMBINED" \
    "--real-time-html" \
    "--output=/usr/local/goaccess/html/index.html" \
    "--geoip-database=$GEO_IP_DB_PATH/GeoLite2-City.mmdb" \
    "--persist" \
    "--restore"
else
  ARGS="--log-file=/usr/local/goaccess/logs/access.log" \
      "--log-format=COMBINED" \
      "--real-time-html" \
      "--output=/usr/local/goaccess/html/index.html" \
      "--persist" \
      "--restore"
fi

# shellcheck disable=SC2086
/bin/goaccess $ARGS
