#!/bin/bash

# If the network is deleted and re-created, this will attach the new network to the container 
docker network connect organize_me_network organize-me-nginx
