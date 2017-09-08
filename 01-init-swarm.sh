#!/bin/bash

./dm-swarm.sh


# create overlay networks
#
docker-machine ssh swarm-1 \
    docker network create --driver overlay proxy
##docker-machine ssh swarm-1 \
##    docker network create --driver overlay elk


# label logger and nonlogger nodes
#
docker-machine ssh swarm-1 \
    docker node update --label-add nonlogger=true swarm-1
docker-machine ssh swarm-1 \
    docker node update --label-add nonlogger=true swarm-2
docker-machine ssh swarm-1 \
    docker node update --label-add nonlogger=true swarm-3
docker-machine ssh swarm-1 \
    docker node update --label-add nonlogger=true swarm-4
docker-machine ssh swarm-1 \
    docker node update --label-add nonlogger=true swarm-5
docker-machine ssh swarm-1 \
    docker node update --label-add logger=true swarm-6
docker-machine ssh swarm-1 \
    docker node update --label-add logger=true swarm-7
