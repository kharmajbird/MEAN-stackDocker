#!/bin/bash

./dm-swarm.sh


docker-machine ssh swarm-1 \
    docker network create --driver overlay proxy
docker-machine ssh swarm-1 \
    docker network create --driver overlay elk

docker node update --label-add nonlogger=true swarm-1
docker node update --label-add nonlogger=true swarm-2
docker node update --label-add nonlogger=true swarm-3
docker node update --label-add nonlogger=true swarm-4
docker node update --label-add nonlogger=true swarm-5
docker node update --label-add logger=true swarm-6
docker node update --label-add logger=true swarm-7
