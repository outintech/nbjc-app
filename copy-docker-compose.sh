#!/bin/bash
# This script scps the specified docker compose file
# to the given ip at the home folder

dockercomposefile="$1"
ip="$2"

scp $dockercomposefile root@$ip:~/docker-compose.yaml

scp .env.$ENV root@$ip:~/
