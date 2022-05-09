#!/bin/bash

# If the network is deleted and re-created, this will attach the new network to the container 
docker network connect home_network nginx
