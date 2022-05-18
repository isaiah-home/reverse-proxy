#!/bin/bash

#examples
# ./certbot.sh renew --dry-run
# ./certbot.sh --nginx --expand --non-interactive --agree-tos -m isaiah.v@comcast.net -d vanderelst.house -d auth.vanderelst.house -d wiki.vanderelst.house -d nextcloud.vanderelst.house -d snipeit.vanderelst.house

ARG="certbot $@"
docker exec -it organize-me-nginx $ARG
