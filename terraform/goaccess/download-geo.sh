#!/bin/sh

# Download GeoLite2-City database, if MAXMIND_LICENSE_KEY is set
if [ -n "$MAXMIND_LICENSE_KEY" ]; then

  # Check if GEO_IP_DB_PATH is set
  if [ -z "$GEO_IP_DB_PATH" ]; then
    echo "GEO_IP_DB_PATH is not set. Exiting..."
    exit 1
  fi

  # Create directory if it doesn't exist
  mkdir -p "$GEO_IP_DB_PATH"

  # Download and extract GeoLite2-City database
  wget -O /tmp/GeoLite2-City.tar.gz "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=${MAXMIND_LICENSE_KEY}&suffix=tar.gz" &&
      tar -xzvf /tmp/GeoLite2-City.tar.gz -C "$GEO_IP_DB_PATH" --strip-components=1 &&
      rm /tmp/GeoLite2-City.tar.gz;
fi
