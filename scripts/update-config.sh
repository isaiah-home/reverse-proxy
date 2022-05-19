#!/bin/sh

cp ../nginx.conf $ORGANIZE_ME_HOME/nginx/nginx.conf
docker restart organize-me-nginx
