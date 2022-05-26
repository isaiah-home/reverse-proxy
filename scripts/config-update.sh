#!/bin/sh

cat nginx.conf | param-filter.sh > $ORGANIZE_ME_HOME/nginx/nginx.conf
docker restart organize-me-nginx
