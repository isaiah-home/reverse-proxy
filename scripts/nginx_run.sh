#!/bin/bash

if [ -z ${NGINX_CONF+x} ];
then
  echo Enter the path to nginx.conf
  read NGINX_CONF
fi

echo NGINX_CONF = $NGINX_CONF

docker run \
  --name nginx \
  --network home_network \
  -v $NGINX_CONF:/etc/nginx/nginx.conf \
  -p 80:80 \
  -p 443:443 \
  isaiah-v/nginx
