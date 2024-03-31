#!/bin/bash

docker stop organize-me-nginx;

docker run -it --rm --name certbot \
 -p 80:80 \
 -p 443:443 \
 -v "$ORGANIZE_ME_HOME/letsencrypt/etc/letsencrypt:/etc/letsencrypt" \
 -v "$ORGANIZE_ME_HOME/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt" \
 certbot/certbot \
 "$@";

docker start organize-me-nginx;
