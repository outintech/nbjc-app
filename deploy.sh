#!/bin/bash
# This script will scp the docker compose file for staging
# To the specified IP

ip="$1"
compose="$2" # defaults to 0

if [ "${compose}" == "up" ]; then
  # Starts the docker containers
    ssh root@$ip 'docker-compose up -d'
    ssh root@$ip 'docker container exec -it api rails db:migrate'
    ssh root@$ip 'docker container exec -it api rails db:seed'
else
  # Stops the docker containers
  ssh root@$ip 'docker-compose down -v --rmi all'
fi
