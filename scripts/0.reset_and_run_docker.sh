#!/bin/bash

# Step 1: Navigate to 0.start_docker, bring down Docker, remove all volumes, and start containers
pushd ../0.start_docker || exit
docker-compose down -v  # Stop and remove containers, networks, images, and volumes
docker-compose up       # Start containers 

popd  # Return to the previous directory
