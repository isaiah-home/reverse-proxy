#!/bin/bash

docker run \
  -d \
  --name organize-me-nginx \
  --network organize_me_network \
  --restart unless-stopped \
  -v $ORGANIZE_ME_HOME/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -p 80:80 \
  -p 443:443 \
  organize-me/nginx
