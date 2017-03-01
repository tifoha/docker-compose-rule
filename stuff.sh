#!/bin/bash

set -x
set -e

env | sort -t=

docker rm -f netcat || true

docker run --name netcat --publish 8080 -d appropriate/nc -lv 8080

PUBLISHED_PORT=$(docker port netcat | cut -d: -f2)

if [[ ! -z "$DOCKER_HOST" ]]; then
  DOCKER_IP=$(echo $DOCKER_HOST | cut -d/ -f3 | cut -d: -f1)
  DOCKER_PORT=$(echo $DOCKER_HOST | cut -d/ -f3 | cut -d: -f2)
  sshpass -p tcuser ssh ${DOCKER_IP} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -M -S -vv redirect-socket -l docker -fN -L 1999:localhost:${PUBLISHED_PORT}
  LOCAL_PORT=1999
else
  LOCAL_PORT=$PUBLISHED_PORT
fi

echo foo | nc localhost $LOCAL_PORT || true

if [[ ! -z "$DOCKER_HOST" ]]; then
  sshpass -p tcuser ssh ${DOCKER_IP} -S redirect-socket -O exit
fi

docker logs netcat
docker rm -f netcat
