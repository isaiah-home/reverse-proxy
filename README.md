# reverse-proxy
Reverse Proxy

## Prerequisites
 * init
 * terraform-aws
 * terraform-local

## Setup
The reverse proxy is setup in the following steps:
 1) Build the docker image (includes nginx and certbot) ([script](scripts/nginx_build.sh))
 2) Set the config file to [nginx.conf.bak](nginx.conf.bak). A basic config that'll allow certbot to run on our domains. ([script](scripts/config-init.sh))
 4) Create and run a container ([script](scripts/nginx_run.sh))
 5) Register domains using certbot
 6) Update to the fully configured [nginx.conf](nginx.conf) ([script](scripts/config-update.sh))

Notes:
 * When copying config files, use param-filter to populate placeholders (The Init repo contains an install script).
 * When running scripts, it's assumed the working directory is the project's root.
