./certbot.sh \
 certonly \
 --expand --non-interactive --agree-tos -m isaiah.v@comcast.net --standalone \
 -d $DOMAIN \
 -d auth.$DOMAIN \
 -d wiki.$DOMAIN \
 -d nextcloud.$DOMAIN \
 -d snipeit.$DOMAIN \
 -d vaultwarden.$DOMAIN \
 -d pihole.$DOMAIN \
 -d homeassistant.$DOMAIN


