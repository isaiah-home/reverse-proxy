#!/bin/bash

#examples
# ./certbot.sh renew --dry-run
# ./certbot.sh --nginx --expand --non-interactive --agree-tos -m isaiah.v@comcast.net -d ivcode.org -d auth.ivcode.org -d wiki.ivcode.org -d nextcloud.ivcode.org -d snipeit.ivcode.org

ARG="certbot $@"
docker exec -it nginx $ARG
