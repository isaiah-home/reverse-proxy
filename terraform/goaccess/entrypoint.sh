#!/bin/sh

if [ -n "$MAXMIND_LICENSE_KEY" ]; then
  # Check if GEO_IP_DB_PATH is set
  if [ -z "$GEO_IP_DB_PATH" ]; then
    echo "GEO_IP_DB_PATH is not set. Exiting..."
    exit 1
  fi

  ARGS="MAXMIND_LICENSE_KEY is set"
else
  ARGS="MAXMIND_LICENSE_KEY is not set"
fi

# shellcheck disable=SC2086
/bin/goaccess $ARGS