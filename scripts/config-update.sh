#!/bin/sh

param-filter.sh -i ../nginx.conf -o $ORGANIZE_ME_HOME/nginx/nginx.conf
docker restart organize-me-nginx
