#!/bin/bash

./dm-swarm.sh

docker-machine ssh swarm-1 \
    docker network create --driver overlay proxy

docker-machine ssh swarm-1 \
    curl -o docker-compose-stack.yml https://raw.githubusercontent.com/vfarcic/docker-flow-proxy/master/docker-compose-stack.yml
docker-machine ssh swarm-1 \
    curl -o docker-compose-mean-demo.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-mean-demo.yml

docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-stack.yml proxy
##docker-machine ssh swarm-1 \
##    docker stack deploy -c docker-compose-mean-demo.yml meany
