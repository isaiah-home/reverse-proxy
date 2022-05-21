#!/bin/sh

#
# Before running certbot for the first time, the proxy needs to be setup will all the domain.
# This script sets up the server for executing cert bot for the frist time.
# The fully configured conf works for subsequent renewals
#

param-filter.sh -i ../nginx.conf.bak -o $ORGANIZE_ME_HOME/nginx/nginx.conf
