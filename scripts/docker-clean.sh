#!/usr/bin/env bash

docker rm --volumes --force `docker ps -qa` > /dev/null 2>&1 || true

docker network prune --force || true
