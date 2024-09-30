./certbot.sh \
 certonly \
 --expand --non-interactive --agree-tos -m isaiah.v@comcast.net --standalone \
 -d "$DOMAIN_BUILD" \
 -d "jenkins.$DOMAIN_BUILD" \
 -d "mvn.$DOMAIN_BUILD" \
 -d "sonar.$DOMAIN_BUILD" \
 -d "registry.$DOMAIN_BUILD" \
 -d "registry-publish.$DOMAIN_BUILD"

